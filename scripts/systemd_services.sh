
#######################################
# Prepares a systemd .service file for start and enable
# Globals:
#   None
# Arguments:
#   - $1: filepath of the .service file
#   - $2: ($WORKING_DIR) the working directory of the service
#   - (optional) $3: the user of the service
# Outputs:
#   None
#######################################

setup_service()
{
    service_filepath=$1
    working_dir=$2
    user=$3 # optional

    service_name=$(basename $service_filepath)

    stop_service $service_name

    if [ -z "$user" ]; then
        user=$(stat -c '%U' $service_filepath)
    fi
    
    # Prepare the service file
    sudo rm -f /tmp/$service_name
    cp $service_filepath /tmp/$service_name
    working_dir_escaped=$(echo $(realpath $working_dir) | sed 's/\//\\\//g')
    sed -i "s/\$USER/${user}/g" /tmp/$service_name
    sed -i "s/\$WORKING_DIR/${working_dir_escaped}/g" /tmp/$service_name

    # Prepare the service to be started or invoked by a timer
    sudo cp /tmp/$service_name /etc/systemd/system
    sudo systemctl enable $service_name --quiet
}

#######################################
# Starts a systemd service
# Globals:
#   None
# Arguments:
#   - $1: name of service
# Outputs:
#   None
#######################################

start_service()
{
    service_name=$1
    sudo systemctl start $service_name --quiet
    sudo systemctl status --no-pager $service_name --lines=0
}

#######################################
# Stops a systemd service safely
# Globals:
#   None
# Arguments:
#   - $1: name of service
# Outputs:
#   None
#######################################

stop_service()
{
    service_name=$1
    timeout 10s bash -c "sudo systemctl --no-ask-password stop $service_name --quiet >> /dev/null &> /dev/null"
    if [ $? -ne 0 ]; then
        sudo systemctl kill -s SIGKILL $service_name >> /dev/null &> /dev/null
    fi
    sudo systemctl disable $service_name --quiet >> /dev/null &> /dev/null
}
