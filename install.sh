#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Used by read_write_config_json.sh
CONFIG_JSON_FILEPATH=$BASEDIR/config.json

# Make sure others can't modify the scripts
chmod o-w $BASEDIR/scripts/*

source $BASEDIR/scripts/ensure_sudo.sh
source $BASEDIR/scripts/read_write_config_json.sh
source $BASEDIR/scripts/user_yes_no.sh
source $BASEDIR/scripts/write_boot_config.sh

#
# Activity LED
#

disable_activity_led()
{
    write_config_json disable_activity_led true
}

user_yes_no "Do you want to disable the Activity LED?" disable_activity_led

#
# Power LED
#

disable_power_led()
{
    write_config_json disable_power_led true
}

user_yes_no "Do you want to disable the Power LED?" disable_power_led

#
# Ethernet LEDs
#

disable_ethernet_leds()
{
    write_config_json disable_ethernet_leds true

    write_boot_config "" true dtparam eth_led0 14
    write_boot_config "" true dtparam eth_led1 14
}

user_yes_no "Do you want to disable the Ethernet LEDs?" disable_ethernet_leds

#
# Bluetooth
#

disable_bluetooth()
{
    write_config_json disable_bluetooth true

    write_boot_config "" false dtoverlay disable-bt
}

user_yes_no "Do you want to disable Bluetooth?" disable_bluetooth

#
# Wifi
#

disable_wifi()
{
    write_config_json disable_wifi true

    write_boot_config "" false dtoverlay disable-wifi
}

user_yes_no "Do you want to disable Wifi?" disable_wifi

#
# HDMI
#

disable_hdmi()
{
    write_config_json disable_hdmi true
}

user_yes_no "Do you want to disable HDMI?" disable_hdmi
