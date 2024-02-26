#!/bin/bash

# Set colors to the accroding variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Turn on network connection
function turnNetworkOn() {
    echo -e "${GREEN}You will now be able to turn your internet connection on. \nPlease connect to Wi-Fi or Ethernet now.${NC}"
    echo -e "\nHit ${GREEN}ENTER${NC} when your internet is connected."
    read

    while true; do
        if ! ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
            clear
            echo "Internet connection is not available."
            echo -e "${RED}Please turn your internet connection on.${NC}"
            echo -e "\nHit ${GREEN}ENTER${NC} when your internet is connected."
            read
        else
            break
        fi
    done
}

turnNetworkOn
