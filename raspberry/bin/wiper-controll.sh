#!/bin/bash

MQTT_SERVER="localhost"
MQTT_SERVERPORT=1883
MQTT_USERNAME="oliverersej"
MQTT_KEY="oliverersej"
MQTT_TOPIC_rain="pico_write"
MQTT_TOPIC_swipe="pico_read"

#check if mqtt has recieved a "1" and take a photo 
mosquitto_sub -t $MQTT_TOPIC_rain -h $MQTT_SERVER -p $MQTT_SERVERPORT -u $MQTT_USERNAME -P $MQTT_KEY | while read -r line; do
    echo "read : $line"
    jq $line
    echo "got $?"
    # if  [ $(jq $line ".rain_detect") == 1 ]
    # then
    #     echo "hej"
    # fi
done