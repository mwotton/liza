{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fno-warn-unticked-promoted-constructors #-}

-- | This code was originally created by squealgen. Edit if you know how it got made and are willing to own it now.
module Schema where

import GHC.TypeLits (Symbol)
import Squeal.PostgreSQL

type PGltree = UnsafePGType "ltree"

type PGcidr = UnsafePGType "cidr"

type PGltxtquery = UnsafePGType "ltxtquery"

type PGlquery = UnsafePGType "lquery"

type DB = '["liza" ::: Schema]

type Schema = Join Tables (Join Views (Join Enums (Join Functions (Join Composites Domains))))

-- enums

-- decls
type Enums =
  ('[] :: [(Symbol, SchemumType)])

type Composites =
  ('[] :: [(Symbol, SchemumType)])

-- schema
type Tables =
  ( '[ "requests" ::: 'Table RequestsTable
     ] :: [(Symbol, SchemumType)]
  )

-- defs
type RequestsColumns =
  '[ "id" ::: 'Def :=> 'NotNull PGint8,
     "endpoint" ::: 'NoDef :=> 'NotNull PGtext,
     "client_id" ::: 'NoDef :=> 'NotNull PGtext,
     "body" ::: 'NoDef :=> 'NotNull PGbytea,
     "error_code" ::: 'NoDef :=> 'NotNull PGint4,
     "created_at" ::: 'Def :=> 'NotNull PGtimestamptz
   ]

type RequestsConstraints = '["requests_pkey" ::: 'PrimaryKey '["id"]]

type RequestsTable = RequestsConstraints :=> RequestsColumns

-- VIEWS
type Views =
  '[]

-- functions
type Functions =
  '[]

type Domains = '[]
