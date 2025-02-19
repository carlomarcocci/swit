-- carlo(
\set ON_ERROR_STOP off

CREATE USER tecu WITH PASSWORD '$TECU_PASS';
CREATE DATABASE tecdb OWNER tecu;
GRANT ALL PRIVILEGES ON DATABASE tecdb TO tecu;

\set ON_ERROR_STOP on
\c tecdb
-- )carlo

