#!/bin/bash

# PC's date
date=$1
date2=$2
space=" "
echo passed date
date+=$space
date+=$date2
echo $date
# Set time on Raspberry Pi

echo "Setting time on Raspberry Pi..."
sudo date --set="$date"




