#!/bin/bash

MQTT_SERVER="localhost"
MQTT_SERVERPORT=1883
MQTT_USERNAME="oliverersej"
MQTT_KEY="oliverersej"
MQTT_TOPIC_rain="pico_write"
MQTT_TOPIC_swipe="pico_read"

while true
do

    json=$(mosquitto_sub -t $MQTT_TOPIC_rain -h $MQTT_SERVER -p $MQTT_SERVERPORT -u $MQTT_USERNAME -P $MQTT_KEY -C 1)

    rein=$(echo "$json" | jq -r ".rain_detect")
    if  [ "$rein" == "1" ]
    then
        mosquitto_pub -t $MQTT_TOPIC_swipe -h $MQTT_SERVER -p $MQTT_SERVERPORT -u $MQTT_USERNAME -P $MQTT_KEY -m "{'wiper_angle': 0}"
        sleep 1
        mosquitto_pub -t $MQTT_TOPIC_swipe -h $MQTT_SERVER -p $MQTT_SERVERPORT -u $MQTT_USERNAME -P $MQTT_KEY -m "{'wiper_angle': 180}"
        sleep 1
        mosquitto_pub -t $MQTT_TOPIC_swipe -h $MQTT_SERVER -p $MQTT_SERVERPORT -u $MQTT_USERNAME -P $MQTT_KEY -m "{'wiper_angle': 0}"
    fi
done