
#######################################
# Prepares a systemd .service file for start and enable
# Globals:
#   None
# Arguments:
#   - $1: filepath of the .service file
#   - $2: ($WORKING_DIR) the working directory of the service
#   - (optional) $3: ($USER) the user of the service
# Outputs:
#   None
#######################################

setup_service()
{
    service_filepath=$1
    working_dir=$2
    service_name=$(basename $service_filepath)
    user=$3 # optional

    if [ -z "$user" ]; then
        user=$(stat -c '%U' $service_filepath)
    fi

    # Kill and disable the old service if its still running
    timeout 10s sudo systemctl --no-ask-password stop $service_name --quiet
    if [ $? -ne 0 ]; then
        sudo systemctl kill -s SIGKILL $service_name
    fi
    sudo systemctl disable $service_name --quiet
    
    # Prepare the service file
    sudo rm -f /tmp/$service_name
    cp $service_filepath /tmp/$service_name
    working_dir_escaped=$(echo $(realpath $working_dir) | sed 's/\//\\\//g')
    sed -i "s/\$USER/${user}/g" /tmp/$service_name
    sed -i "s/\$WORKING_DIR/${working_dir_escaped}/g" /tmp/$service_name

    # Prepare the service to be started or invoked by a timer
    sudo cp /tmp/$service_name /etc/systemd/system
    sudo systemctl enable $service_name
}
