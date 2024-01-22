#!/bin/bash

STOP="${HOME}/git/swit/ionoparser/stop.int"

if [ -f ${STOP} ]; then
    echo "One file loading ON"
else
    touch ${STOP}
    echo "One file loading set ON"
fi
