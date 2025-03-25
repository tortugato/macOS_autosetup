#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")

# Install Scripts
function installScripts(){
    sleep 1
    echo -e "${BOLD}Installing Scripts...${NC}"

    function installScript() {
        local success=true
        local prompt="$1"
        local command_to_run="$2"

        echo -e "${BOLD}$prompt${NC}"
        echo -e "Running the command..."
        eval "$command_to_run"

        if [ $? -ne 0 ]; then
            success=false
        fi

        if [ "$success" = true ]; then
            echo -e "${GREEN}Successful${NC}\n"
        else
            echo -e "${RED}Failed${NC}\n"
        fi
    }

    installCleanupScript="
    mkdir -p ~/.local/bin &&
    cp '$main_dir/resources/installscripts/cleanup' ~/.local/bin/ &&
    chmod +x ~/.local/bin/cleanup &&
    ( [ -e ~/.local/bin/cleanup ] )
    "

    installMacaddressRandomizer="
    mkdir -p /usr/local/sbin &&
    chown ${USER}:admin /usr/local/sbin &&
    cp '$main_dir/resources/installscripts/spoof.sh' '/usr/local/sbin/spoof.sh' &&
    chmod +x /usr/local/sbin/spoof.sh &&
    cp '$main_dir/resources/installscripts/local.spoof.plist' '/Library/LaunchDaemons/local.spoof.plist' &&
    [ -e '/usr/local/sbin/spoof.sh' ]
    "

    installUpdateScript="
    cp '$main_dir/resources/installscripts/update' ~/.local/bin/ &&
    chmod +x ~/.local/bin/update &&
    ( [ -e ~/.local/bin/update ] )
    "

    installSufoScript="
    cp '$main_dir/resources/installscripts/sufo' ~/.local/bin/ &&
    chmod +x ~/.local/bin/sufo &&
    ( [ -e ~/.local/bin/sufo ] )
    "

    installzshrc="
    cp '$main_dir/resources/installscripts/zshrc' ~/.zshrc &&
    ( [ -e ~/.zshrc ] )
    "

    installScript "Installing Cleanup Script" "$installCleanupScript"
    installScript "Installing Mac Address Randomizer" "$installMacaddressRandomizer"
    installScript "Installing Update Script" "$installUpdateScript"
    installScript "Installing Sufo Script" "$installSufoScript"
    installScript "Installing zshrc" "$installzshrc"
}

installScripts
sleep 1
source ~/.zshrc
