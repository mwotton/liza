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
        createNamedEndpoint
        :: route
          :- "namedEndpoint"
          :> Capture "name" Text
      --        :> ReqBody '[JSON] Value
          :> ReqBody '[JSON] EndpointSpec
          :> Put '[JSON] NoContent

        -- | this is grotty, would be nicer to have some wrapped Raw thing.
        --   We really don't want any content type negotiation here.
      , failWithChance
        :: route
          :- "failWithChance"
          :> Capture "failChance" Double
--          :> Capture "endpoint" Text
--          :> Capture "client_id" Text
          :> ReqBody '[JSON] Value
          :> Post '[JSON] NoContent

      -- , fetchNamedEndpoint
      --   :: route
      --   :- "namedEndpoint"
      --   :> Capture "name" Text
      --   :> Get '[JSON] [Problem]
      , fetchByEndpoint
        :: route
          :- "fetchByEndpoint"
          :> Capture "key" Text
          :> Get '[JSON] [RequestLog]
      , healthcheck
        :: route
          :- "healthcheck"
          :> Get '[JSON] [Problem]
      }
  deriving (Generic)

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy @Routes)
