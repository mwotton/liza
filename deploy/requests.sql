-- Deploy liza:requests to pg

BEGIN;

SET search_path TO liza,public;

CREATE TABLE requests (
    id bigserial primary key,
    endpoint TEXT NOT NULL,
    body TEXT NOT NULL,
    error_code int4 not null,
    created_at timestamptz not null default CURRENT_TIMESTAMP
);

create index endpoint_idx on requests using btree("endpoint");
create index bytime_idx on requests using btree("created_at");

COMMIT;
