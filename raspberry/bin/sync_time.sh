#!/bin/bash

# PC's date
date=$1
echo passed date
echo $date

# Set time on Raspberry Pi

echo "Setting time on Raspberry Pi..."
sudo date --set="$date"




