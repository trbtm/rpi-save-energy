#!/bin/bash
# nano /home/pi/safe_power.sh
# chmod u+x /home/pi/safe_power.sh

if [[ "$1" == "activate" ]]; then
    # Disable Activity LED
    echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null || true

    # Disable Power LED
    # Raspberry Pi 3B / 3B+ / 4B
    echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null || true

    # Turn off HDMI
    sudo /opt/vc/bin/tvservice -o || true

    sudo systemctl disable hciuart.service || true
    sudo systemctl disable bluealsa.service || true
    sudo systemctl disable bluetooth.service || true

elif [[ "$1" == "deactivate" ]]; then
    # Activity LED
    echo 1 | sudo tee /sys/class/leds/led0/brightness > /dev/null || true
    # Power LED
    echo 1 | sudo tee /sys/class/leds/led1/brightness > /dev/null || true
    # HDMI
    sudo /opt/vc/bin/tvservice -p || true

    sudo systemctl enable hciuart.service || true
    sudo systemctl enable bluealsa.service || true
    sudo systemctl enable bluetooth.service || true
fi
