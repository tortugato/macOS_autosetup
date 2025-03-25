#!/bin/bash

# Set colors to the according variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Introduction test
function introduction(){
    echo -e "${BOLD}\nWELCOME TO THE SETUP${NC}"
    echo -e "This setup script aims to set up MacOS in the most private and secure way possible. \nThis script performs steps that I consider necessary and unavoidable to use MacOS privately and securely. \nI will continue to improve this script, so please keep an eye on the Github repository for possible changes. \nIf you have any suggestions for improvement, please post an issue to Github, I will try to take care of it as soon as possible.
    \n\n${BOLD}If you wish to install a firewall, a vpn, custom homebrew packages and/or your dotfiles please make sure to put them into the correct directories.${NC}
    \n\nLets get started. Here is an overview of the steps this script will guide you through.
    \n1) Activating FileVault
    \n2) Installation of helpful scripts
    \n3) Setting important settings
    \n4) Removing unneccessary features
    \n5) Installation of a Firewall (optional)
    \n6) Installation of a VPN (optional)
    \n7) Installation of the Brew Package Manager
    \n8) Installation of some basic packages
    \n9) Installation of custom packages (optional)
    \n10) Installation of dotfies (optional)
    \n11) Cleaning up the look of MacOS (optional)"

    echo -e "\n\nHit ${GREEN}ENTER${NC} to continue or ${RED}CTRL+C${NC} to abort."
    read

    echo -e "${BOLD}Please consider to reset your macOS system and set it up as described in the README before running this script.${NC}"
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read
}

introduction
