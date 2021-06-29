{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DerivingVia #-}


module RoboservantSpec where

import Data.Time
import DBHelpers
import AroundAll
import Manager
import API
import Server
import Roboservant
import Hedgehog
import Test.Hspec
import Roboservant.Types.Breakdown
import Roboservant.Types.BuildFrom

import qualified Roboservant as RS
import qualified Roboservant.Server as RS
import Env(Env)
import Types
import Data.Aeson(Value(..))
import Servant
import Servant.API.Flatten(Flat)
-- defaultConfig :: RS.Config
-- defaultConfig = RS.Config
--                 { RS.seed = []
--                 , RS.maxRuntime = 0.5
--                 , RS.maxReps = 1000
--                 , RS.rngSeed = 0
--                 , RS.coverageThreshold = 0
--                 }

spec :: Spec
spec = describe "api" $ do

  aroundAll withEnv $
    it "works sequentially" $ \env -> do
      RS.fuzz @(Flat API) (hoistedServer env) defaultConfig { RS.coverageThreshold = 0.3 }
        >>= (`shouldSatisfy` isNothing)

deriving via RS.Atom Value instance RS.Breakdown Value
deriving via RS.Atom Value instance RS.BuildFrom Value

deriving via RS.Compound EndpointSpec instance RS.Breakdown EndpointSpec
deriving via RS.Compound EndpointSpec instance RS.BuildFrom EndpointSpec

-- deriving via RS.Atom Foo instance RS.Breakdown Foo
-- instance (Hashable x, Typeable x, RS.Breakdown x) => RS.Breakdown [x] where
--   breakdownExtras r = hashedDyn r:fmap hashedDyn r



-- shift
deriving via RS.Atom Double instance RS.Breakdown Double
deriving via RS.Atom Double instance RS.BuildFrom Double

deriving via RS.Atom Text instance RS.Breakdown Text
deriving via RS.Atom Text instance RS.BuildFrom Text


deriving via RS.Atom Int64 instance RS.Breakdown Int64
deriving via RS.Atom Int64 instance RS.BuildFrom Int64

deriving via RS.Atom Int32 instance RS.Breakdown Int32
deriving via RS.Atom Int32 instance RS.BuildFrom Int32

deriving via RS.Atom Seconds instance RS.Breakdown Seconds
deriving via RS.Atom Seconds instance RS.BuildFrom Seconds


deriving via RS.Compound RequestLog instance RS.Breakdown RequestLog
deriving via RS.Compound RequestLog instance RS.BuildFrom RequestLog

deriving via RS.Compound Limit instance RS.Breakdown Limit
deriving via RS.Compound Limit instance RS.BuildFrom Limit

deriving via RS.Compound Problem instance RS.Breakdown Problem
deriving via RS.Compound Problem instance RS.BuildFrom Problem

deriving via RS.Compound MultipleDelivery instance RS.Breakdown MultipleDelivery
deriving via RS.Compound MultipleDelivery instance RS.BuildFrom MultipleDelivery

deriving via RS.Atom UTCTime instance RS.Breakdown UTCTime
deriving via RS.Atom UTCTime instance RS.BuildFrom UTCTime
