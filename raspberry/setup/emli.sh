#!/bin/bash

setpriv --reuid nxquadsat --regid nxquadsat --init-groups ~/pillip/run_wildcam.sh &
PID=$!

wait=$PID
