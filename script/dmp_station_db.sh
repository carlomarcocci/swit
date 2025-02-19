pg_dump --column-inserts -h$1 -Upostgres -p$2 $3 -t constellation -t institution -t instrument -t producer -t satellite -t station_belong_institution -t type_table -t station_has_instrument -t station  -t status -t station_instrument_period 

