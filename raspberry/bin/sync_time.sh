#!/bin/bash

# PC's date
date=$1

# Set time on Raspberry Pi

echo "Setting time on Raspberry Pi..."
sudo date "$($date)"




