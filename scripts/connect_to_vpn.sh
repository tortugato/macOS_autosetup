#!/bin/bash

# Set colors to the accroding variables
GREEN='\033[0;32m'
NC='\033[0m'

function connectToWifi() {
    echo -e "${GREEN}Please connect to your VPN now if you chose to install one.${NC}\nIf your Firewall prompts you, accept the connections made by the VPN."
    echo -e "\nHit ${GREEN}ENTER${NC} when your VPN is connected."
    read

}

connectToWifi
