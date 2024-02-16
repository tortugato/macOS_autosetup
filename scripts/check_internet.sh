#!/bin/bash

# Set colors to the accroding variables
RED='\033[0;31m'
NC='\033[0m'

# Requirements functions
# Check if internet connection is available
function checkInternetConnectionOff() {
    if ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
        echo "Internet connection is available."
        echo -e "${RED}Please turn your internet connection off and restart the script.${NC}"
        exit 1
    fi
}

checkInternetConnectionOff
