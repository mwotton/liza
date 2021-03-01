-- Deploy liza:foos to pg
-- requires: appschema

BEGIN;

create table liza.foos (
        id serial primary key,
	name text not null
);

COMMIT;
