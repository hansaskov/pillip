#!/bin/bash

mkdir -p ~/log
interface=$(iwconfig 2>/dev/null | grep -Eo '^[a-z]+' | head -n 1)

if [ -n "$interface" ]; then
    link_quality=$(grep "$interface" /proc/net/wireless | awk '{ print $3 }')
    signal_strength=$(grep "$interface" /proc/net/wireless | awk '{ print $4 }')
    echo "$(date +"%Y-%m-%d %H:%M:%S") Link Quality: $link_quality, Signal Strength: $signal_strength" >> ~/log/wireless.log
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") No WiFi interface found" >> ~/log/wireless.log
fi