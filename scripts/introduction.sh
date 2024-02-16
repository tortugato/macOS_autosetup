#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Introduction test
function introduction(){
    echo -e "${BOLD}\nWELCOME TO THE SETUP${NC}"
    echo -e "This setup script aims to set up MacOS in the most private and secure way possible. \nThis script performs steps that I consider necessary and unavoidable to use MacOS privately and securely. \nI will continue to improve this script, so please keep an eye on the Github repository for possible changes. \nIf you have any suggestions for improvement, please post an issue to Github, I will try to take care of it as soon as possible.
    \n\nLets get started. Here is an overview of the steps this script will guide you through.
    \n1) Activating FileVault if not already activated
    \n2) Installation of helpful scripts
    \n3) Setting important questions
    \n4) Removing unneccessary features
    \n5) Installation of a Firewall
    \n6) Installation of a VPN
    \n7) Installtion of the Brew packagemanager
    \n8) Installation of some basic packages
    \n9) Installation of custom packages
    \n10) Cleaning up the look of MacOS"

    echo -e "\n\nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} to abort."
    read

    echo -e "After the initial setup of your system according to the README we will now configure the macOS system for privacy and security."
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read
}

introduction
