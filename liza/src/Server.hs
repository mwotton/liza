{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import           API                    (API, api, Routes (..))
import           Manager                (App, runDB, runApp)
import           Queries                (getAllFoosQ)
import Env
import Control.Exception(try)
import           Servant
import           Servant.Server.Generic (genericServerT)
import           Squeal.PostgreSQL      (execute, getRows)
import Servant.Server (hoistServer)
import System.Random



-- probably this should have a custom monad but it doesn't bother
-- me too badly for now.
server :: ServerT API App
server = genericServerT $ Routes
  { failWithChance = \failChance -> do
      c <- liftIO $ randomRIO (0,1)
      if c < failChance
        then error "oops, we made a fucky-wucky"
        else pure NoContent
  }
--  where run = liftIO . runApp e

hoistedServer env = hoistServer api (nt env) server

nt :: Env -> Manager.App x -> Handler x
nt env = Handler . ExceptT . try . runApp env
