from serial import Serial
import paho.mqtt.client as mqtt
from functools import partial
import argparse

def driver(pico_port:str,pico_band:int,mqtt_url:str,mqtt_port:int,mqtt_username:str = "",mqtt_password:str = "",mqtt_read_topic = "/pico_read",mqtt_write_topic = "/pico_write",):
    ser = Serial(pico_port,pico_band)
    mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    mqttc.on_connect = partial(on_connect,topic=mqtt_read_topic)
    mqttc.on_message = partial(on_message,serial=ser)
    mqttc.username = mqtt_username
    mqttc.password = mqtt_password
    mqttc.connect(mqtt_url, mqtt_port, 60)
    mqttc.loop_start()
    while True:
        data = ser.readline()
        # print(data)
        mqttc.publish(mqtt_write_topic,data)

def on_connect(client:mqtt.Client, userdata, flags, reason_code, properties,topic):
    print(f"Connected with result code {reason_code}")
    client.subscribe(topic)

def on_message(client, userdata, msg,serial:Serial):
    serial.write(msg.payload)





if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = "pico driver")
    parser.add_argument("-S","--serial",type=str,default="/dev/pico")
    parser.add_argument("-b","--band",type=int,default=115200)
    parser.add_argument("-u","--url",type=str,default="10.0.0.10")
    parser.add_argument("-P","--port",type=int,default=1883)
    parser.add_argument("-U","--username",type=str,default="")
    parser.add_argument("-W","--password",type=str,default="")
    parser.add_argument("-tr","--topic-read",type=str,default="/pico_read" )
    parser.add_argument("-tw","--topic-write",type=str,default="/pico_write" )
    args = parser.parse_args()
    driver(args.serial,args.band,args.url,args.port,args.username,args.password,args.topic_read,args.topic_write)