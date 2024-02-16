#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(realpath "$0")")")

# Cleanup Script Installation
function installScripts(){
    sleep 1
    echo -e "${BOLD}Installing Scripts...${NC}"

    function installScripts() {
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
    mkdir -p /usr/local/bin &&
    cp '$main_dir/installscripts/cleanup' '/usr/local/bin/cleanup'
    "

    installAppCleanerScript="
    cp '$main_dir/installscripts/app-cleaner' '/usr/local/bin/app-cleaner'
    "

    installMacaddressRandomizer="
    mkdir -p /usr/local/sbin &&
    chown ${USER}:admin /usr/local/sbin &&
    touch ~/.zshrc &&
    echo 'export PATH=$PATH:/usr/local/sbin' >> ~/.zshrc &&
    source ~/.zshrc &&
    cp '$main_dir/installscripts/spoof.sh' '/usr/local/sbin/spoof.sh' &&
    chmod +x /usr/local/sbin/spoof.sh &&
    cp '$main_dir/installscripts/local.spoof.plist' '/Library/LaunchDaemons/local.spoof.plist'
    "

    installLogoutHook="
    cp '$main_dir/installscripts/spoof-hook.sh' '/usr/local/sbin/spoof-hook.sh' &&
    chmod +x /usr/local/sbin/spoof-hook.sh
    defaults delete com.apple.loginwindow LogoutHook
    defaults write com.apple.loginwindow LogoutHook '/usr/local/sbin/spoof-hook.sh'
    defaults read com.apple.loginwindow
    "

    installScripts "Installing Cleanup Script" "$installCleanupScript"
    installScripts "Installing App Cleaner Script" "$installAppCleanerScript"
    installScripts "Installing Mac Address Randomizer" "$installMacaddressRandomizer"
    installScripts "Installing Logout Hook" "$installLogoutHook"
}

installScripts