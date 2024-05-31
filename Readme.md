# Wildlife Camera Photo Gathering Project

## Project Overview

This project involves a sophisticated system designed to capture, process, and store images of wildlife using a Raspberry Pi-based camera. The system integrates various components to enhance its functionality and security, providing a robust solution for wildlife monitoring.

### Key Components
1. **Wildlife Camera**: A Raspberry Pi-based camera system that captures images periodically, through motion detection, or triggered by an external source such as a pressure plate.
2. **Raspberry Pi Pico**: Monitors a rain sensor and controls a servo-operated wiper to keep the camera lens clear.
3. **ESP8266 Module**: Acts as a trigger for capturing photos when animals activate the pressure plate.
4. **Drone Integration**: Connects to the camera via WiFi, securely transfers photos and metadata, and uploads them to the cloud for processing.
5. **Cloud Processing**: Annotates and processes the captured photos using a large language model (LLM) to provide detailed descriptions and metadata.

### Directory Structure
```plaintext
.
├── cloud
│   ├── annotate_photos.sh
│   └── annotate.sh
├── drone
│   ├── Drone_flight.sh
│   ├── log_wifi.sh
│   ├── sqlite_view_log.sh
│   └── wifi_data.db
├── esp8266
│   └── esp8266_count_mqtt.ino
├── photos
│   ├── 2024-04-23
│   │   ├── 141225_751.jpg
│   │   └── 141225_751.json
│   ├── 2024-04-30
│   ├── 2024-05-09
├── raspberry
│   ├── bin
│   │   ├── extract_photo_metadata.sh
│   │   ├── save_photo.sh
│   │   ├── sync_time.sh
│   │   ├── take_photo_every_second.sh
│   │   ├── take_photo.sh
│   │   ├── trigger_take_photo.sh
│   │   └── wiper-controll.sh
│   ├── gallery
│   ├── pico-driver
│   │   ├── create_pico_udev.sh
│   │   └── pico-driver.py
│   ├── py
│   │   ├── motion.py
│   │   ├── requirements.in
│   │   └── requirements.txt
│   ├── run_wildcam.sh
│   └── setup
│       ├── emli.service
│       ├── emli.sh
│       └── setup.sh
└── README.md
