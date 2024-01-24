#!/bin/bash

# Get the path for the script directory
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
USER=$(whoami)

# Get the width of the terminal window
width=$(tput cols)

# Set colors to the accroding variables
BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


# Start of Script
echo -e "\n${BOLD}Welcome to the setup${NC} \n \nPlease make sure to store your VPN of choice as ${ITALIC}vpn.pkg/vpn.dmg${NC} and a firewall of you choice as ${ITALIC}firewall.dmg${NC} in the directory of this script. \n(directory: $script_dir/) \n \nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} if you have to add the files:"

# Wait for Enter
read 

#Linebreak
printf "%${width}s\n" | tr ' ' '-' 

echo -e "\nAfter the initial setup of your system according to the ReadMe/Video we will now configure the macOS system for privacy and security."

echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read
# First Installs

echo -e "\nFirst we will start by installing a firewall and a vpn. \nAfter this we will turn on the network connection. \n${BOLD}Note: We will configure LittleSnitch to block all connections made by Apple in the default profile and allow only the update connections in the update profile. More on that later${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read
echo -e "\nPlease make sure to follow the instructions by the LittleSnitch installer carefully! \n${BOLD}Make sure: \n1) Uncheck Apple Services and iCloud Services during the last step of installation \n2) Allow Notifications and the System Extension by LittleSnitch \n3) Click on DemoMode as we won't be able to active LittleSnitch now \n4) Turn on Alert Mode (not Silent Mode)${NC}"
printf "%${width}s\n" | tr ' ' '-' 


echo -e "\nHit ${GREEN}ENTER${NC} to start the installation"
read

# Install of firewall
sudo hdiutil attach firewall.dmg
rsync -a /Volumes/Little\ Snitch*/Little\ Snitch.app /Applications
sleep 5
sudo hdiutil unmount /Volumes/Little\ Snitch*
open /Applications/Little\ Snitch.app 

echo -e "\n${GREEN}The Firewall was successfully installed.${NC}"
printf "%${width}s\n" | tr ' ' '-' 
echo -e "\n${RED}Please follow the setup process for LittleSnitch before continuing.${NC}"
echo -e "\n${BOLD}REMINDER: \n1) Uncheck Apple Services and iCloud Services during the last step of installation \n2) Allow Notifications and the System Extension by LittleSnitch \n3) Click on DemoMode as we won't be able to active LittleSnitch now \n4) Turn on Alert Mode (not Silent Mode)${NC}"


# Install of VPN
echo -e "Now we will install the VPN."
echo -e "\nHit ${GREEN}ENTER${NC} to continue"

read
sudo installer -package vpn.pkg -target /


# Turn on network connection
open /Applications/Mullvad\ VPN.app


# Brew
# Settings through terminal
# Cleanup Script Installation
# App-Cleaner Script Installation