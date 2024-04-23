#!/bin/bash

# PC's IP address
ip_address=$1

# Fetch current time from PC using SSH
date=$(ssh user@$ip_address date "+%Y-%m-%d %H:%M:%S")

# Set time on Raspberry Pi
set_time() {
    echo "Setting time on Raspberry Pi..."
    sudo date "$($date)"
}

# Set time on Raspberry Pi
set_time



