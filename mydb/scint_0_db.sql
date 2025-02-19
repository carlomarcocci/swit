-- carlo(
\set ON_ERROR_STOP off

CREATE USER scintu WITH PASSWORD '$SCINTU_PASS';
CREATE DATABASE scint OWNER scintu;
GRANT ALL PRIVILEGES ON DATABASE scint TO scintu;

\set ON_ERROR_STOP on
\c scint
-- )carlo

