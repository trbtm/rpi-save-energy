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
source $BASEDIR/scripts/systemd_services.sh

restart=false
needs_service=false

#
# Power LED
#

disable_power_led()
{
    write_config_json disable_power_led true

    write_boot_config "" true dtparam pwr_led_trigger none
    write_boot_config "" true dtparam pwr_led_activelow off
    restart=true
}

user_yes_no "Do you want to disable the Power LED?" disable_power_led

#
# Activity LED
#

disable_activity_led()
{
    write_config_json disable_activity_led true

    write_boot_config "" true dtparam act_led_trigger none
    write_boot_config "" true dtparam act_led_activelow off
    restart=true
}

user_yes_no "Do you want to disable the Activity LED?" disable_activity_led

#
# Ethernet LEDs
#

# https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README
ethernet_off=0
model=$(tr -d '\0' < /proc/device-tree/model)
if [[ $model == *"3 Model B Plus"* ]]; then
    ethernet_off=14
elif [[ $model == *"4 Model B"* ]]; then
    ethernet_off=4
fi

if [ $ethernet_off -ne 0 ]; then

    disable_ethernet_leds()
    {
        write_config_json disable_ethernet_leds true

        write_boot_config "" true dtparam eth_led0 $ethernet_off
        write_boot_config "" true dtparam eth_led1 $ethernet_off
        restart=true
    }

    user_yes_no "Do you want to disable the Ethernet LEDs?" disable_ethernet_leds
fi

#
# Bluetooth
#

disable_bluetooth()
{
    write_config_json disable_bluetooth true

    write_boot_config "" false dtoverlay disable-bt
    stop_service hciuart.service
    stop_service bluealsa.service
    stop_service bluetooth.service
    restart=true
}

user_yes_no "Do you want to disable Bluetooth?" disable_bluetooth

#
# Wifi
#

disable_wifi()
{
    write_config_json disable_wifi true

    write_boot_config "" false dtoverlay disable-wifi
    restart=true
}

user_yes_no "Do you want to disable Wifi?" disable_wifi

#
# HDMI
#

disable_hdmi()
{
    write_config_json disable_hdmi true

    # Make sure the new KMS driver is deactivated, otherwise HDMI can't be disabled by tvservice
    write_boot_config "#" false dtoverlay vc4-kms-v3d
    needs_service=true
    restart=true
}

user_yes_no "Do you want to disable HDMI?" disable_hdmi


if [ "$needs_service" = true ]; then
    setup_service $BASEDIR/services/save_energy.service $BASEDIR
    start_service save_energy.service
fi

if [ "$restart" = true ]; then
    reboot()
    {
        sudo reboot now
    }
    user_yes_no "You need to reboot for all changes to take effect. Do you want to REBOOT now?" reboot
fi
