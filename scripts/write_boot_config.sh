
#######################################
# Writes or modyfies config options to /boot/config.txt
# Globals:
#   None
# Arguments:
#   - $1: '""'' or '#' whether you want to activate or deactivate the option
#   - $2: is the option unique, e.g. dtoverlay occurs multiple times ['true' | 'false']
#   - $3 to $i: the options and their respective value like 'dtparam=audio=off' => '"" dtparam audio off'
# Outputs:
#   None
#######################################

write_boot_config()
{
    comment=$1
    unique=$2

    arg_regex="^\s*#*\s*$3"
    arg_string="$comment$3"
    for (( i=4; i <= "$# - 1"; i++ )); do
        arg_regex="$arg_regex\s*=\s*${!i}"
        arg_string="$arg_string=${!i}"
    done

    if [ "$unique" = false ]; then
        arg_regex="$arg_regex\s*=\s*${!#}$"
    else
        arg_regex="$arg_regex\s*=.*$"
    fi

    arg_string="$arg_string=${!#}"
    option_exists=$(sudo sed -n -r "/$arg_regex/p" /boot/config.txt | grep "" -c)

    if (( option_exists > 0 )); then
        sudo sed -i -r "s/$arg_regex/$arg_string/" /boot/config.txt
    else
        echo $arg_string | sudo tee -a /boot/config.txt >> /dev/null
    fi
}
