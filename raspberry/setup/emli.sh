#!/bin/bash
echo "test"
setpriv --reuid pi --regid pi --init-groups ~/pillip/raspberry/run_wildcam.sh &
PID=$!
wait=$PID
