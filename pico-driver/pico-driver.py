from serial import Serial
import paho.mqtt.client as mqtt
from functools import partial

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
    print(msg.topic+" "+str(msg.payload))
    serial.write(msg.payload)





if __name__ == '__main__':
    driver("/dev/ttyACM0",115200,"10.0.0.10",1883,"oliverersej","oliverersej")