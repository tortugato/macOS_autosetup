#!/bin/bash

# Clear the terminal before use
clear

# Get the path for the script directory
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# Get the width of the terminal window
width=$(tput cols)

# Set colors to the accroding variables
BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


# Start of Script
echo -e "${BOLD}WELCOME TO THE SETUP${NC} \n\nPlease make sure to store your VPN of choice as ${ITALIC}vpn.pkg/vpn.dmg${NC} and a firewall of you choice as ${ITALIC}firewall.dmg${NC} in the directory of this script. \n(directory: $script_dir/) \n\nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} if you have to add the files"
read 
clear

echo -e "After the initial setup of your system according to the README/Video we will now configure the macOS system for privacy and security."
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read
clear

echo -e "First we will start by installing a Firewall and a VPN. \nAfter this we will turn on the network connection."
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read

# -----------------------------------------------------------------------------------------

# Display the menu to choose which firewall to install
echo "\nWhich Firewall do you want to install? (enter the number): "
options=("LittleSnitch" "LuLu")

select firewall_choice in "${options[@]}"; do
    case $firewall_choice in
        "LittleSnitch")
            firewall_name="Little Snitch"
            firewall_install_note="\n1) Uncheck Apple Services and iCloud Services during the last step of installation \n2) Allow Notifications and the System Extension by LittleSnitch \n3) Click on DemoMode as we won't be able to active the LittleSnitch license now \n4) Turn on Alert Mode (not Silent Mode)"
            break
            ;;
        "LuLu")
            firewall_name="LuLu"
            firewall_install_note="\n1) Uncheck Allow Apple Programs and Allow Already Installed Applications during the installation \n2) Allow Notifications and the System Extension by LuLu"
            break
            ;;
        *)
            echo "Invalid option, please choose 1 or 2."
            ;;
    esac
done

echo -e "\nPlease make sure to follow the instructions by the $firewall_name installer carefully! \n${BOLD}Make sure: $firewall_install_note ${NC}"
printf "%${width}s\n" | tr ' ' '-' 

# Start the installation
echo -e "\nHit ${GREEN}ENTER${NC} to start the installation (you will be prompted for your password)"
read

# Mount the DMG
sudo hdiutil attach firewall.dmg

# Get the directory of the mounted volume
if [[ "$firewall_name" == "Little Snitch" ]]; then
    app_name=$(find "/Volumes" -maxdepth 1 -type d -name "${firewall_name}*" | grep -E "${firewall_name} [0-9.]+" | head -n 1)
elif [[ "$firewall_name" == "LuLu" ]]; then
    app_name=$(find "/Volumes" -maxdepth 1 -type d -name "${firewall_name}*" | grep -E "${firewall_name} v[0-9.]+" | head -n 1)
fi

# Copy the .app file to /Applications
rsync -a "${app_name}/${firewall_name}.app" "/Applications/"
sleep 5

# Unmount the DMG
sudo hdiutil detach "${app_name}/"
sleep 3

#Open the firewall
open "/Applications/${firewall_name}.app"
clear

echo -e "${GREEN}The Firewall was successfully installed.${NC}"
echo -e "\n${RED}Please follow the setup process for LittleSnitch before continuing.${NC}"
echo -e "\n${BOLD}REMINDER: $firewall_install_note"
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read 

# -----------------------------------------------------------------------------------------

# Install of VPN


# -----------------------------------------------------------------------------------------


# Brew
# Settings through terminal
# Cleanup Script Installation
# App-Cleaner Script Installation