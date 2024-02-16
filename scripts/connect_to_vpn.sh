#!/bin/bash

# Set colors to the accroding variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

function connectToVPN() {

    echo -e "\nPlease make sure to ${BOLD}turn the Killswitch on.${NC} \n${RED}If your Firewall prompts you, accept the connections made by the VPN.${NC}"
    echo -e "\nOpen you VPN, login and enable the Killswitch."

    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read
    echo -e "${GREEN}Please connect to your VPN now.${NC}"
    echo -e "\nHit ${GREEN}ENTER${NC} when your VPN is connected."
    read

}

connectToVPN
