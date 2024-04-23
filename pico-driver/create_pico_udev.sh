#!/bin/bash
sudo tee /etc/udev/rule.d/99-pico.rules << 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000a", ATTRS{serial}=="E6605481DB404C37", MODE="0666", SYMLINK+="pico_01"'