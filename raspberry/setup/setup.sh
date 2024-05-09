#!/bin/bash

sudo scp emli.sh /usr/sbin/
sudo scp emli.service /etc/systemd/system/

sudo systemctl start emli
sudo systemctl enable emli
