#!/bin/bash

# Set colors to the accroding variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check if Filevault is on
function checkFilevault(){
    filevault_status=$(fdesetup status)
    if [[ "$filevault_status" != "FileVault is On." ]]; then
        echo "FileVault is not enabled. Enabling FileVault..."
        fdesetup enable
        echo -e "\n${RED}Please save the Recovery Key in a secure location, e.g. your password manager.${NC}
        \nHit ${GREEN}ENTER${NC} to continue"
        read
    fi
}

checkFilevault
