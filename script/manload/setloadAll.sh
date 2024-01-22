#!/bin/bash

STOP="/home/eswua/git/swit/ionoparser/stop.int"

if [ -f ${STOP} ]; then
    rm -f ${STOP}
    echo "ALL files loading ON"
else
    echo "ALL files loading set ON"
fi
