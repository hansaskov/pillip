#!/bin/bash
cd ~/pillip/raspberry

bin/take_photo_every_second.sh &
cd gallery && bun run src/index.tsx &
pico-driver/pico-driver.py &
bin/wiper-controll.sh &
bin/trigger_take_photo.sh


