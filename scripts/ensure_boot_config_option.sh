
#######################################
# Writes or modyfies config options to /boot/config.txt
# Globals:
#   None
# Arguments:
#   - $1: '""'' or '#' whether you want to activate or deactivate the option
#   - $2 to $i: the options and their respective value like 'dtparam=audio=off' => '"" dtparam audio off'
# Outputs:
#   None
#######################################

ensure_boot_config_option()
{
    arg_regex="^\s*#*\s*$2"
    arg_string="$1$2"
    for (( i=3; i <= "$# - 1"; i++ )); do
        arg_regex="$arg_regex\s*=\s*${!i}"
        arg_string="$arg_string=${!i}"
    done
    arg_regex="$arg_regex\s*=.*$"
    arg_string="$arg_string=${!#}"
    option_exists=$(sudo sed -n -r "/$arg_regex/p" /boot/config.txt | grep "" -c)
    if (( option_exists > 0 )); then
        sudo sed -i -r "s/$arg_regex/$arg_string/" /boot/config.txt
    else
        echo $arg_string | sudo tee -a /boot/config.txt
    fi
}
