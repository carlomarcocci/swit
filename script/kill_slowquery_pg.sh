#!/bin/bash

DELAY=$5
# Query execution to terminate backend processes active for more than 60 seconds
QUERY="SELECT NOW(), pg_terminate_backend(pid), datname, usename, query_start::timestamp without time zone, query FROM pg_stat_activity WHERE state = 'active' AND now() - query_start > interval '${DELAY} seconds';"

# Function to execute query for a given database
execute_query() {
  local db_host=$1
  local db_port=$2
  local db_user=$3
  local db_name=$4

  psql -t -h "$db_host" -p "$db_port" -U "$db_user" -d "$db_name" -c "$QUERY"
}

# Esecuzione dello script con i parametri in input
execute_query "$@"

