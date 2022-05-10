
#######################################
# Asks the user a question, if yes executes another function
# Globals:
#   None
# Arguments:
#   - $1: Question to answer
#   - $2: Function to execute on yes
# Outputs:
#   None
#######################################

user_yes_no()
{
    while true; do
        read -p "$1 (y/n) " yn
        case $yn in
        [Yy]* ) 
            $2;
            break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
        esac
    done
}
