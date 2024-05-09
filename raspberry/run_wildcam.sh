#!/bin/bash
cd ~/pillip/raspberry

bin/take_photo_every_second.sh &
bun run gallery/src/index.tsx &
pico-driver/pico-driver.py &
bin/wiper-controll.sh &
bin/trigger_take_photo.sh