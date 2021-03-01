-- Revert liza:requests from pg

BEGIN;

drop table liza.requests;
COMMIT;
