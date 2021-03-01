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
  ( '[ "foos" ::: 'Table FoosTable
     ] :: [(Symbol, SchemumType)]
  )

-- defs
type FoosColumns =
  '[ "id" ::: 'Def :=> 'NotNull PGint4,
     "name" ::: 'NoDef :=> 'NotNull PGtext
   ]

type FoosConstraints = '["foos_pkey" ::: 'PrimaryKey '["id"]]

type FoosTable = FoosConstraints :=> FoosColumns

-- VIEWS
type Views =
  '[]

-- functions
type Functions =
  '[]

type Domains = '[]
