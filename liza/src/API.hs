{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE DeriveGeneric    #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators    #-}

module API where

import           Servant
import           Servant.API.Generic
import           Types

type API = ToServantApi Routes

data Routes route
  = Routes
      { failWithChance
        :: route
        :- "failWithChance"
        :> Capture "failChance" Double
        :> Capture "key" Text
        :> Post '[JSON] NoContent
      }
  deriving (Generic)

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy @Routes)
