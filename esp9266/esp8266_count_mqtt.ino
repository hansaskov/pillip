

// Embedded Linux (EMLI)
// University of Southern Denmark

// 2022-03-24, Kjeld Jensen, First version

// Configuration
#define WIFI_SSID       "EMLI-TEAM-15"
#define WIFI_PASSWORD    "pillip15"

#define MQTT_SERVER      "192.168.10.1"
#define MQTT_SERVERPORT  1883
#define MQTT_USERNAME    "oliverersej"
#define MQTT_KEY         "oliverersej"
#define MQTT_TOPIC       "/trigger" 

// wifi
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
ESP8266WiFiMulti WiFiMulti;
const uint32_t conn_tout_ms = 5000;

// counter
#define GPIO_INTERRUPT_PIN 4
#define DEBOUNCE_TIME 100 
volatile unsigned long count_prev_time;
volatile unsigned long count;
#define trigger 1

// mqtt
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_Client.h"
WiFiClient wifi_client;
Adafruit_MQTT_Client mqtt(&wifi_client, MQTT_SERVER, MQTT_SERVERPORT, MQTT_USERNAME, MQTT_KEY);
Adafruit_MQTT_Publish count_mqtt_publish = Adafruit_MQTT_Publish(&mqtt, MQTT_USERNAME MQTT_TOPIC);

// publish
#define PUBLISH_INTERVAL 30
unsigned long prev_post_time;

// debug
#define DEBUG_INTERVAL 2000
unsigned long prev_debug_time;

//ICACHE_RAM_ATTR void count_isr()
//{
  //if (count_prev_time + DEBOUNCE_TIME < millis() || count_prev_time > millis())
  //{
  //  count_prev_time = millis(); 
   // count++;
 // }
//}

void debug(const char *s)
{
  Serial.print (millis());
  Serial.print (" ");
  Serial.println(s);
}

void mqtt_connect()
{
  int8_t ret;

  // Stop if already connected.
  if (! mqtt.connected())
  {
    debug("Connecting to MQTT... ");
    while ((ret = mqtt.connect()) != 0)
    { // connect will return 0 for connected
         Serial.println(mqtt.connectErrorString(ret));
         debug("Retrying MQTT connection in 5 seconds...");
         mqtt.disconnect();
         delay(5000);  // wait 5 seconds
    }
    debug("MQTT Connected");
  }
}

void print_wifi_status()
{
  Serial.print (millis());
  Serial.print(" WiFi connected: ");
  Serial.print(WiFi.SSID());
  Serial.print(" ");
  Serial.print(WiFi.localIP());
  Serial.print(" RSSI: ");
  Serial.print(WiFi.RSSI());
  Serial.println(" dBm");
}

void setup()
{
  // count
  count_prev_time = millis();
  count = 0;
  pinMode(GPIO_INTERRUPT_PIN, INPUT_PULLUP);


  attachInterrupt(digitalPinToInterrupt(GPIO_INTERRUPT_PIN), publish_data, RISING);
  //Serial.print();

  // serial
  Serial.begin(115200);
  delay(10);
  debug("Boot");

  // wifi
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(WIFI_SSID, WIFI_PASSWORD);
  if(WiFiMulti.run(conn_tout_ms) == WL_CONNECTED)
  {
    print_wifi_status();
  }
  else
  {
    debug("Unable to connect");
  }
  mqtt_connect();
}

ICACHE_RAM_ATTR void publish_data()
{
  if (count_prev_time + DEBOUNCE_TIME < millis() || count_prev_time > millis())
  {
    count = 0;
    Serial.print(millis());
    Serial.println(" Connecting...");
    if((WiFiMulti.run(conn_tout_ms) == WL_CONNECTED))
    {
      print_wifi_status();
      if (! count_mqtt_publish.publish(trigger))
      {
        debug("MQTT failed");
      }
      else
      {
        debug("MQTT is gucci");
      }
    }
    count_prev_time = millis(); 
    count++;
  }
}

void loop()
{



}

