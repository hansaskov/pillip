#!/bin/bash

# PC's IP address
ip_address=$1

# Fetch current time from PC using SSH
echo "getting date from drone..."
date=$(ssh user@$ip_address date "+%Y-%m-%d %H:%M:%S")

# Set time on Raspberry Pi

echo "Setting time on Raspberry Pi..."
sudo date "$($date)"




