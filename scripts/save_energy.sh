#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Used by read_write_config_json.sh
CONFIG_JSON_FILEPATH=$BASEDIR/../config.json

source $BASEDIR/read_write_config_json.sh

# Disable Activity LED
if [ $(read_config_json disable_activity_led) = "true" ] ; then
    echo 0 | sudo tee /sys/class/leds/led0/brightness > /dev/null || true
fi

# Disable Power LED
if [ $(read_config_json disable_power_led) = "true" ] ; then
    echo 0 | sudo tee /sys/class/leds/led1/brightness > /dev/null || true
fi

# Disable all bluetooth services
if [ $(read_config_json disable_bluetooth) = "true" ] ; then
    sudo systemctl disable hciuart.service || true
    sudo systemctl disable bluealsa.service || true
    sudo systemctl disable bluetooth.service || true
fi

# Disable HDMI
if [ $(read_config_json disable_hdmi) = "true" ] ; then
    sudo tvservice --off || true
fi
