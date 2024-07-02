#!/bin/bash

# Set colors to the accroding variables
RED='\033[0;31m'
NC='\033[0m'

# Get the list of all network interfaces
all_interfaces=$(networksetup -listallnetworkservices)

# Requirements functions
# Check if internet connection is available
function checkInternetConnectionOff() {

    while true; do
        if ! ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
            clear
            echo -e "${BOLD}Internet connection is not available.${NC}"
            echo -e "${RED}Please turn your internet connection on.${NC}"
            echo -e "\nHit ${GREEN}ENTER${NC} when your internet is connected."
            read
        else
            break
        fi
    done

}

checkInternetConnectionOff
