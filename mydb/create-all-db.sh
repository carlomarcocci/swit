#!/bin/bash

PATTA=`pwd`

${PATTA}/mydb/create-db.sh swit
${PATTA}/mydb/create-db.sh ais
${PATTA}/mydb/create-db.sh scint
${PATTA}/mydb/create-db.sh tecdb
