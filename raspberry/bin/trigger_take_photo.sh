#!/usr/bin/env bash


# Set the MQTT server hostname or IP address and the topic to subscribe to

MQTT_SERVER="localhost"
MQTT_SERVERPORT=1883
MQTT_USERNAME="oliverersej"
MQTT_KEY="oliverersej"
MQTT_TOPIC="oliverersej/trigger"




#check if mqtt has recieved a "1" and take a photo 
mosquitto_sub -t "$MQTT_TOPIC" -h "$MQTT_SERVER" -p "$MQTT_PORT" -u "$MQTT_USERNAME" -P "$MQTT_KEY"| while read -r line; do
    if [ "$line" = "1" ]; then
        echo "an animal has stepped on the trigger"
        ./take_photo.sh ~/photos External
        #call take_photo.sh?
        # do something
    fi
done