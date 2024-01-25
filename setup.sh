#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the width of the terminal window
width=$(tput cols)

# Get the path for the script directory
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# Clear the terminal before use
clear

# -----------------------------------------------------------------------------------------

# Make sure User meets requirements for setup

# Run the entire script with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this script with sudo.${NC}"
    exit 1
fi

# Check if Filevault is on
filevault_status=$(fdesetup status)

if [[ "$filevault_status" != "FileVault is On." ]]; then
    echo "FileVault is not enabled. Enabling FileVault..."
    fdesetup enable
    echo -e "\n${RED}Please save the Recovery Key in a secure location, e.g. you password manager of choice.${NC} \nHit ${GREEN}ENTER${NC} to start the setup"
    read
fi

# Check if internet connection is available
function check_internet_connection() {
    if ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
        echo "Internet connection is available."
        echo -e "${RED}Please turn you internet connection off and restart the script.${NC}"
        exit 1
    fi
}

check_internet_connection

# Check if VPN and Firewall files are in directory
if ! ( [ -e "$script_dir/vpn.pkg" ] || [ -e "$script_dir/vpn.dmg" ] ) || [ ! -e "$script_dir/firewall.dmg" ]; then
    echo -e "${RED}Not all files required for this setup are in $script_dir.${NC}"
    echo "Please double check to include a vpn and a firewall file. (vpn.pkg/vpn.dmg and firewall.dmg)"
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read
fi

# -----------------------------------------------------------------------------------------

clear

# Start of Script
echo -e "${BOLD}WELCOME TO THE SETUP${NC} \n\nPlease make sure to store your VPN of choice as ${BOLD}vpn.pkg/vpn.dmg${NC} and a firewall of you choice as ${BOLD}firewall.dmg${NC} in the directory of this script.\n${ITALIC}(directory: $script_dir/)${NC}"
echo -e "\n\nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} if you have to add the files"
read 
clear

echo -e "After the initial setup of your system according to the README/Video we will now configure the macOS system for privacy and security."
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read
clear


# -----------------------------------------------------------------------------------------

# Remove unneccessary features
echo -e "First we will disable a few unneccessary features. \nYou will be asked if you want a feature to be disabled."
echo -e "\nHit ${GREEN}ENTER${NC} to start"
read

function run_command() {
    local prompt="$1"
    local command_to_run="$2"

    echo -n "$prompt (y/n): "
    read choice

    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Running the command..."
        # Run the specified command
        eval "$command_to_run"
    elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
        echo "Exiting without running the command."
    else
        echo "Invalid choice. Please enter 'y' or 'n'."
    fi
}

# Run Commands
diable_siri="
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false &&
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3 &&
launchctl disable 'user/$UID/com.apple.assistantd' &&
launchctl disable 'gui/$UID/com.apple.assistantd' &&
sudo launchctl disable 'system/com.apple.assistantd' &&
launchctl disable 'user/$UID/com.apple.Siri.agent' &&
launchctl disable 'gui/$UID/com.apple.Siri.agent' &&
sudo launchctl disable 'system/com.apple.Siri.agent' &&
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True &&
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0 &&
defaults write com.apple.Siri 'StatusMenuVisible' -bool false &&
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true &&
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2"

disable_remote_connections="
sudo systemsetup -setremotelogin off &&
sudo launchctl disable 'system/com.apple.tftpd' &&
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true &&
sudo launchctl disable system/com.apple.telnetd &&
cupsctl --no-share-printers &&
cupsctl --no-remote-any &&
cupsctl --no-remote-admin"

run_command "Do you want to Disable Spotlight? (you can install an alternative like Raycast/Alfred later)" "mdutil -i off && mdutil -E"
run_command "Do you want to Disable Siri? (recommended)" "$disable_siri"
run_command "Do you want to Disable AirDrop? (recommended)" "defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"
run_command "Do you want to Disable Remote Connections? (recommended)" "$disable_remote_connections"
run_command "Do you want to Disable Gatekeeper (recommended)" "spctl --master-disable"

# -----------------------------------------------------------------------------------------
echo -e "Next we will install a Firewall and a VPN. \nAfter this we will turn on the network connection."
echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read


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
sudo hdiutil attach "$script_dir/vpn_and_firewall/firewall.dmg"

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
echo -e "\nHit ${GREEN}ENTER${NC} when you are finished setting up $firewall_name"
read 

# -----------------------------------------------------------------------------------------

# Installation of VPN
clear
echo -e "Now we will install the VPN."

echo "Which VPN do you want to install? (enter the number): "
options=("ProtonVPN" "Mullvad")

select firewall_choice in "${options[@]}"; do
    case $firewall_choice in
        "ProtonVPN")
			vpn_name="ProtonVPN"
			sudo hdiutil attach "$script_dir/vpn_and_firewall/vpn.dmg"
			rsync -a "/Volumes/ProtonVPN/ProtonVPN.app" "/Applications/"
			sleep 5
			sudo hdiutil detach "/Volumes/ProtonVPN/"
			sleep 3
            break
            ;;
        "Mullvad")
			vpn_name="Mullvad VPN"
			sudo installer -package vpn.pkg -target /
            break
            ;;
        *)
            echo "Invalid option, please choose 1 or 2."
            ;;
    esac
done

clear
echo -e "${GREEN}The VPN was successfully installed.${NC}"
echo -e "\nPlease make sure to ${BOLD}turn the Killswitch on${NC}, then we will continue with the network connectivity. \n${RED}If you get prompted by $firewall_name to allow traffic by $vpn_name, click on allow${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} to open the $vpn_name."
read
open "/Applications/${vpn_name}.app"


echo -e "\nHit ${GREEN}ENTER${NC} to continue"
read 


# -----------------------------------------------------------------------------------------
# Cleanup Script Installation
# App-Cleaner Script Installation
# MacAddressRandomizer on Restart
# Settings through terminal
## Set Hostname
## Clean Up Dock
# Turn on network connection
# Brew




