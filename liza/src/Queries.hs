{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE KindSignatures #-}

{-# LANGUAGE TypeApplications #-}
-- {-# LANGUAGE TypeOperators #-}

module Queries where

import Schema (DB)
import Squeal.PostgreSQL hiding (name)
import Types (RequestLog)
import Data.Time(UTCTime)
import qualified Data.ByteString.Lazy as L

logRequest :: Statement DB (Text,Text,L.ByteString,Int32) ()
logRequest = manipulation $
  insertInto_ (#liza ! #requests)
  (Values_ (Default `as` #id
             :* Set (param @1) `as` #endpoint
             :* Set (param @2) `as` #client_id
             :* Set (param @3) `as` #body
             :* Set (param @4) `as` #error_code
             :* Default `as` #created_at
           ))

fetchRequestByEndpoint :: Statement DB (Only Text) RequestLog
fetchRequestByEndpoint = query q
  where q :: Query_ DB (Only Text) RequestLog
        q =
          select_ (#id :*  #endpoint :* #client_id
                   -- :* #body
                   :* #error_code :* #created_at)
          (from (table (#liza ! #requests))
           & where_ (#requests ! #endpoint .== param @1)
           & orderBy [Asc #created_at]
          )
