{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import           API                    (API, api, Routes (..))
import           Manager                (App, runDB, runApp)
--import           Queries                (getAllFoosQ)
import Env
import Control.Exception(try)
import           Servant
import           Servant.Server.Generic (genericServerT)
import           Squeal.PostgreSQL
import Servant.Server (hoistServer)
import System.Random
import Queries
import Data.Aeson
import Types



-- probably this should have a custom monad but it doesn't bother
-- me too badly for now.
server :: ServerT API App
server = genericServerT $ Routes
  { failWithChance = failer
  , fetchByEndpoint = fetcher
  , healthcheck = healthcheck'
  }
--  where run = liftIO . runApp e

failer :: Double -> Text -> Text -> Value -> App NoContent
failer failChance key clientId body =  do
  c <- liftIO $ randomRIO (0,1)
  let broken = c < failChance
  let error_code = if broken
        then 500
        else 200
  runDB $ executeParams logRequest (key, clientId, encode body, error_code)
  if broken
    then error "oopsywoopsy, a fuckywucky"
    else pure NoContent


fetcher key = runDB $ getRows =<< executeParams fetchRequestByEndpoint (Only key)


healthcheck' = runDB $ do
  multideliveries <- getRows =<< execute fetchMultipleDeliveries
  pure $ fmap PMultipleDelivery multideliveries

hoistedServer env = hoistServer api (nt env) server

nt :: Env -> Manager.App x -> Handler x
nt env = Handler . ExceptT . try . runApp env
