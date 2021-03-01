-- Revert liza:foos from pg

BEGIN;

drop table liza.foos;

COMMIT;
