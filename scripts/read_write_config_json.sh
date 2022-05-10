
#######################################
# Reads values from config json
# Globals:
#   $CONFIG_JSON_FILEPATH
# Arguments:
#   - $1: Key
# Outputs:
#   The value belonging to the Key
#######################################
read_config_json()
{
    key=$1

    config_value=$(python3 << END
from json import load
from os import path
from sys import stdout as stdout

if path.isfile("$CONFIG_JSON_FILEPATH"):
    with open("$CONFIG_JSON_FILEPATH", "r") as f:
        config = load(f)
else:
    config = {}

stdout.write(f"{config.get('$key', '')}")
END
)
    echo $config_value
}

#######################################
# Writes values to config json
# Globals:
#   $CONFIG_JSON_FILEPATH
# Arguments:
#   - $1: Key
#   - $2: Value
# Outputs:
#   None
#######################################
write_config_json()
{
    key=$1
    value=$2

    python3 << END
from json import dump, load
from os import path

if path.isfile("$CONFIG_JSON_FILEPATH"):
    with open("$CONFIG_JSON_FILEPATH", "r") as f:
        config = load(f)
else:
    config = {}

config["$key"] = "$value"

with open("$CONFIG_JSON_FILEPATH", "w") as f:
    dump(config, f, indent=4, sort_keys=True)
END
}
