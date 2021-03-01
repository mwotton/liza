{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Types where

import Data.Aeson(ToJSON,FromJSON)
import qualified GHC.Generics as GHC
import qualified Generics.SOP as SOP
import Data.Hashable
import Data.Time

data RequestLog
  = RequestLog
      { id :: Int64
      , endpoint :: Text
      , body :: Text
      , error_code :: Int32
      , created_at :: UTCTime
      }
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

-- instance Hashable RequestLog
instance ToJSON RequestLog
instance FromJSON RequestLog
