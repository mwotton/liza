-- Verify liza:foos on pg

BEGIN;

select name from liza.foos where false;

ROLLBACK;
