#!/usr/bin/env bash


# Set the MQTT server hostname or IP address and the topic to subscribe to
MQTT_SERVER="192.168.10.1"
MQTT_TOPIC="/trigger"

# Connect to the MQTT server and subscribe to the topic
mosquitto_sub -h $MQTT_SERVER -t $MQTT_TOPIC


#check if mqtt has recieved a "1" and take a photo 
mosquitto_sub -t "$MQTT_TOPIC" | while read -r line; do
    if [ "$line" = "1" ]; then
        echo "an animal has stepped on the trigger"
        take_photo.sh ~/photos External
        #call take_photo.sh?
        # do something
    fi
done