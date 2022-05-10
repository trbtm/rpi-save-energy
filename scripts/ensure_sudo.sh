if groups | grep "\<sudo\>" &> /dev/null -ne 0; then
    tput setaf 1; echo "This script must be run as a sudo user."; tput sgr0
    exit 1
fi
