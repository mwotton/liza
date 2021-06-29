{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE UndecidableInstances #-}

module Types where

import Data.Aeson(ToJSON,FromJSON)
import qualified GHC.Generics as GHC
import qualified Generics.SOP as SOP
import Data.Hashable
import Data.Time
import qualified Data.ByteString.Lazy as L
import Squeal.PostgreSQL
import Data.Hashable.Time()

data RequestLog
  = RequestLog
      { id :: Int64
      , endpoint :: Text
      , client_id :: Text
--      , body :: L.ByteString
      , error_code :: Int32
      , created_at :: UTCTime
      }
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)





newtype Seconds = Seconds Int
  deriving (Generic,Eq)
  deriving anyclass (Hashable)

instance FromJSON Seconds

data Limit
  = Limit
    { limitSeconds :: Int
    , limitMaxHooks :: Int
    }
  deriving (Generic,Eq)
  deriving anyclass (Hashable)
instance FromJSON Limit
instance ToJSON Limit

data EndpointSpec
  = EndpointSpec
    { failChance :: Double
    , limits :: [Limit]
    }
  deriving Generic
  deriving anyclass (Hashable)
instance FromJSON EndpointSpec

instance Hashable RequestLog
instance ToJSON RequestLog
instance FromJSON RequestLog

data Problem
  = PMultipleDelivery MultipleDelivery
  | PFailedToRetry -- currently unimplemented
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo, Hashable)
instance ToJSON Problem
instance FromJSON Problem


data MultipleDelivery =
  MultipleDelivery
  { targeted_endpoint :: Text
  , attempt_id :: Text
--  , failures :: AttemptList
--  , successes :: AttemptList
  }
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo, Hashable)
  deriving (IsPG, FromPG) via (Composite MultipleDelivery)

instance ToJSON MultipleDelivery
instance FromJSON MultipleDelivery

-- data Attempt =
--   Attempt
--   { attempted_at :: UTCTime
--   , attempt_error_code :: Int32
--   }
--   deriving stock (Show, GHC.Generic, Eq)
--   deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)
--   deriving (IsPG, FromPG) via (Composite Attempt)
-- instance ToJSON Attempt
-- instance FromJSON Attempt



-- newtype AttemptList = AttemptList [Attempt]
--   deriving stock (Show, GHC.Generic, Eq)
--   deriving (IsPG, FromPG) via (VarArray [Attempt])

-- instance ToJSON AttemptList
-- instance FromJSON AttemptList
