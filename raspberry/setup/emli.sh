#!/bin/bash

setpriv --reuid nxquadsat --regid nxquadsat --init-groups ~/pillip/raspberry/run_wildcam.sh &
PID=$!
wait=$PID
