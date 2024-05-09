#!/bin/bash
echo "test"
setpriv --reuid pi --regid pi --init-groups ~/pillip/run_wildcam.sh &
PID=$!

wait=$PID
