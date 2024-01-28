#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# Clear the terminal before use
clear

# -----------------------------------------------------------------------------------------
# Requirements functions

# Run the entire script with sudo
function check_sudo(){
    if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this script with sudo.${NC}"
    exit 1
    fi
}

# Check if Filevault is on
function check_filevault(){
    filevault_status=$(fdesetup status)
    if [[ "$filevault_status" != "FileVault is On." ]]; then
        echo "FileVault is not enabled. Enabling FileVault..."
        fdesetup enable
        echo -e "\n${RED}Please save the Recovery Key in a secure location, e.g. your password manager.${NC} 
        \nHit ${GREEN}ENTER${NC} to continue"
        read
    fi
}

# Check if internet connection is available
function check_internet_connection() {
    if ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
        echo "Internet connection is available."
        echo -e "${RED}Please turn your internet connection off and restart the script.${NC}"
        exit 1
    fi
}

# -----------------------------------------------------------------------------------------
# Introduction test
function introduction(){
    clear
    echo -e "${BOLD}WELCOME TO THE SETUP${NC}"
    echo -e "This setup script aims to set up MacOS in the most private and secure way possible. \nThis script performs steps that I consider necessary and unavoidable to use MacOS privately and securely. \nI will continue to improve this script, so please keep an eye on the Github repository for possible changes. \nIf you have any suggestions for improvement, please post an issue to Github, I will try to take care of it as soon as possible.
    \n\nLets get started. Here is an overview of the steps this script will guide you through.
    \n1) Deactivation of unneccessary features
    \n2) Installation of helpful scripts
    \n3) Setting a generic Hostname & MacAddress Randomizer
    \n4) Changing some basic Settings
    \n5) Cleaning up the look of MacOs
    \n6) Installation of a Firewall
    \n7) Installation of a VPN
    \n8) Installation of other helpful software"

    echo -e "\n\nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} to abort."
    read 
    clear

    echo -e "After the initial setup of your system according to the ReadME we will now configure the macOS system for privacy and security."
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read
     
}

# -----------------------------------------------------------------------------------------
# Remove unneccessary features
function disable_features() {
    clear
    echo -e "We will disable a few unneccessary features. \nYou will be asked if you want a feature to be disabled."
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
            echo -e "${GREEN}Successfull${NC}\n"
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "Exiting without running the command. \n"
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    }

    # Run Commands
    disable_spotlight="
    mdutil -i off && 
    mdutil -E"

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

    disable_airdrop="
    defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"

    disable_remote_connections="
    sudo systemsetup -setremotelogin off &&
    sudo launchctl disable 'system/com.apple.tftpd' &&
    sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true &&
    sudo launchctl disable system/com.apple.telnetd &&
    cupsctl --no-share-printers &&
    cupsctl --no-remote-any &&
    cupsctl --no-remote-admin"

    disable_gatekeeper="
    spctl --master-disable"

    disable_power_options="
    pmset -a tcpkeepalive 0 &&
    pmset -a powernap 0 &&
    pmset -a networkoversleep 0 &&
    pmset -a ttyskeepawake 0 &&
    pmset -a womp 0"

    run_command "Do you want to Disable Spotlight? (you can install an alternative like Raycast/Alfred later)" "$disable_spotlight"
    run_command "Do you want to Disable Siri? (recommended)" "$disable_siri"
    run_command "Do you want to Disable AirDrop? (recommended)" "$disable_airdrop"
    run_command "Do you want to Disable Remote Connections? (recommended, but it can take a few seconds to complete)" "$disable_remote_connections"
    run_command "Do you want to Disable Gatekeeper (recommended)" "$disable_gatekeeper"
    run_command "Do you want to Disable Power Options (recommended)" "$disable_power_options"
}

# -----------------------------------------------------------------------------------------
# Cleanup Script Installation
function install_cleanup_script(){
    mkdir -p /usr/local/bin
    mv "$script_dir/scripts/cleanup" "/usr/local/bin/cleanup"
}

# App-Cleaner Script Installation
function install_app_cleaner_script(){
    mv "$script_dir/scripts/app-cleaner" "/usr/local/bin/app-cleaner"
}

# MacAddressRandomizer on Restart
function install_macaddress_randomizer(){
    mkdir -p /usr/local/sbin
    mv "$script_dir/scripts/spoof.sh" "/usr/local/sbin/spoof.sh"
    mv "$script_dir/scripts/local.spoof.plist" "/Library/LaunchDaemons/local.spoof.plist"
    eval spoof.sh
}

# Settings through terminal
function setSettings(){
    ## firewall defaults write /Library/Preferences/com.apple.alf globalstate -int 1
    ## hidden files
    ## recent files
    ## disable ask to join hotspots
    ## time from ntp
}

# Clean up the look
function cleanLook(){

}

# -----------------------------------------------------------------------------------------
# Installation of a Firewall
function install_firewall(){
    clear
    echo -e "Next we will install a Firewall."

    # Check if firewall.dmg file is in folder
    while true; do
        if [ ! -e "$script_dir/vpn_and_firewall/firewall.dmg" ]; then
            clear
            echo -e "${RED}Not all files required for this setup are in $script_dir/vpn_and_firewall/.${NC}"
            echo "Please double-check to include the firewall file. (firewall.dmg)"
            read -p "Press Enter to retry or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
            exit 1
            fi
        else
            clear
            break  # Exit the loop if files are present
        fi
    done

    echo -e "Hit ${GREEN}ENTER${NC} to start the installation"
    read

    # Display the menu to choose which firewall to install
    echo -e "\nWhich Firewall do you want to install? (enter the number): "
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
}

# -----------------------------------------------------------------------------------------
# Installation of VPN
function install_vpn(){
    clear

    # Check if vpn.dmg file is in folder
    echo "Which VPN do you want to install? (enter the number): "
    options=("ProtonVPN" "Mullvad")

    select vpn_choice in "${options[@]}"; do
        case $vpn_choice in
            "ProtonVPN")
                vpn_name="ProtonVPN"
                vpn_file="$script_dir/vpn_and_firewall/vpn.dmg"
                break
                ;;
            "Mullvad")
                vpn_name="Mullvad VPN"
                vpn_file="$script_dir/vpn_and_firewall/vpn.pkg"
                break
                ;;
            *)
                echo "Invalid option, please choose 1 or 2."
                ;;
        esac
    done

    # Check if the selected VPN file exists
    while true; do
        if [ ! -e "$vpn_file" ]; then
            clear
            echo -e "${RED}The required VPN file ($vpn_name) is missing at $vpn_file.${NC}"
            echo "Please make sure to include the correct VPN file before proceeding."
            read -p "Press Enter to retry or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
                exit 1
            fi
        else
            break  # Exit the loop if VPN file is present
        fi
    done

    # Continue with installation based on the selected VPN
    if [ "$vpn_name" == "ProtonVPN" ]; then
        sudo hdiutil attach "$vpn_file"
        rsync -a "/Volumes/ProtonVPN/ProtonVPN.app" "/Applications/"
        sleep 5
        sudo hdiutil detach "/Volumes/ProtonVPN/"
        sleep 3
    elif [ "$vpn_name" == "Mullvad VPN" ]; then
        sudo installer -package "$vpn_file" -target /
    fi

    clear
    echo -e "${GREEN}The VPN was successfully installed.${NC}"
    echo -e "\nPlease make sure to ${BOLD}turn the Killswitch on${NC}, then we will continue with the network connectivity. \n${RED}If you get prompted by $firewall_name to allow traffic by $vpn_name, click on allow${NC}"
    echo -e "\nHit ${GREEN}ENTER${NC} to open the $vpn_name."
    read

    open "/Applications/${vpn_name}.app"
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read 
}



# -----------------------------------------------------------------------------------------

# Turn on network connection
# Brew

# -----------------------------------------------------------------------------------------
function run_functions() {
    local prompt="$1"
    local command_to_run="$2"
    local valid_choice=false

    while [ "$valid_choice" == false ]; do
        
        echo -n "$prompt (y/n): "
        read -r choice

        if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
            # Run the specified command
            eval "$command_to_run"
            clear
            valid_choice=true
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "Continuing without running the function. \n"
            valid_choice=true
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    done
}

# Run functions 
# Checks first
check_sudo
check_filevault
check_internet_connection

# Introduction
introduction

# Install Scripts
install_cleanup_script
install_app_cleaner_script
install_macaddress_randomizer

# Optional but recommended installs
run_functions "Do you want to Disable Features? (recommended)" "disable_features"
run_functions "Do you want to Install a Firewall? (highly recommended)" "install_firewall"
run_functions "Do you want to Install a VPN? (recommended)" "install_vpn"
