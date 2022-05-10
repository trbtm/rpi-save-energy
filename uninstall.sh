#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Used by read_write_config_json.sh
CONFIG_JSON_FILEPATH=$BASEDIR/config.json

if [ ! -f $CONFIG_JSON_FILEPATH ]; then
    echo "$CONFIG_JSON_FILEPATH does not exist."
    exit 1
fi

source $BASEDIR/scripts/ensure_sudo.sh
source $BASEDIR/scripts/read_write_config_json.sh
source $BASEDIR/scripts/user_yes_no.sh
source $BASEDIR/scripts/write_boot_config.sh
source $BASEDIR/scripts/systemd_services.sh

#
# Power LED
#

if [ $(read_config_json disable_power_led) = "true" ]; then
    write_boot_config "#" true dtparam pwr_led_trigger none
    write_boot_config "#" true dtparam pwr_led_activelow off
fi

#
# Activity LED
#

if [ $(read_config_json disable_activity_led) = "true" ]; then
    write_boot_config "#" true dtparam act_led_trigger none
    write_boot_config "#" true dtparam act_led_activelow off
fi

#
# Ethernet LEDs
#

if [ $(read_config_json disable_ethernet_leds) = "true" ]; then
    write_boot_config "" true dtparam eth_led0 0
    write_boot_config "" true dtparam eth_led1 0

    write_boot_config "#" true dtparam eth_led0 0
    write_boot_config "#" true dtparam eth_led1 0
fi

#
# Bluetooth
#

if [ $(read_config_json disable_bluetooth) = "true" ]; then
    write_boot_config "#" false dtoverlay disable-bt

    sudo systemctl enable hciuart.service >> /dev/null &> /dev/null
    sudo systemctl enable bluetooth.service >> /dev/null &> /dev/null
    sudo systemctl enable bluealsa.service >> /dev/null &> /dev/null
fi

#
# Wifi
#

if [ $(read_config_json disable_wifi) = "true" ]; then
    write_boot_config "#" false dtoverlay disable-wifi
fi

#
# HDMI
#

if [ $(read_config_json disable_hdmi) = "true" ]; then
    echo "Depending on your Raspberry Pi model you might want enable the modern graphics driver."
    echo "Uncomment dtoverlay vc4-kms-v3d in /boot/config.txt to do that."
fi


stop_service save_energy.service
rm -f $CONFIG_JSON_FILEPATH

reboot()
{
    sudo reboot now
}
user_yes_no "You need to reboot for all changes to take effect. Do you want to REBOOT now?" reboot
