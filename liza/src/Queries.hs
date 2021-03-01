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

logRequest :: Statement DB (Text,Text,Int32) ()
logRequest = manipulation $
  insertInto_ (#liza ! #requests)
  (Values_ (Default `as` #id
             :* Set (param @1) `as` #endpoint
             :* Set (param @2) `as` #body
             :* Set (param @3) `as` #error_code
             :* Default `as` #created_at
           ))

fetchRequestByEndpoint :: Statement DB (Only Text) RequestLog
fetchRequestByEndpoint = query q
  where q :: Query_ DB (Only Text) RequestLog
        q =
          select_ (#id :* #endpoint :* #body :* #error_code :* #created_at)
          (from (table (#liza ! #requests))
           & where_ (#requests ! #endpoint .== param @1)
           & orderBy [Asc #created_at]
          )
