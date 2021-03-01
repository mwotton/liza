-- Deploy liza:index_name to pg

BEGIN;

create index foos_name_index on liza.foos(name);

COMMIT;
