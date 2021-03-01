{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE DeriveGeneric    #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators    #-}

module API where

import Data.Aeson(Value)
import           Servant
import           Servant.API.Generic
import           Types
import Servant.RawM.Server

type API = ToServantApi Routes

data Routes route
  = Routes
      {
        -- | this is grotty, would be nicer to have some wrapped Raw thing.
        --   We really don't want any content type negotiation here.
        failWithChance
        :: route
        :- "failWithChance"
        :> Capture "failChance" Double
        :> Capture "endpoint" Text
        :> Capture "client_id" Text
        :> ReqBody '[JSON] Value
        :> Post '[JSON] NoContent
      , fetchByEndpoint
        :: route
        :- "fetchByEndpoint"
        :> Capture "key" Text
        :> Get '[JSON] [RequestLog]
      }
  deriving (Generic)

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy @Routes)
