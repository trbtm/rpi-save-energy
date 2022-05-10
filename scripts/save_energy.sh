#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Used by read_write_config_json.sh
CONFIG_JSON_FILEPATH=$BASEDIR/../config.json

if [ ! -f $CONFIG_JSON_FILEPATH ]; then
    echo "$CONFIG_JSON_FILEPATH does not exist."
    exit 0
fi

source $BASEDIR/read_write_config_json.sh

# Disable HDMI
if [ $(read_config_json disable_hdmi) = "true" ]; then
    sudo tvservice --off || true
fi
