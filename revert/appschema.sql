-- Revert liza:appschema from pg

BEGIN;

drop schema liza;

COMMIT;
