#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(realpath "$0")")")

# Installation of VPN
function installVpn(){
    clear

    # Check if vpn.dmg file is in folder
    echo "Which VPN do you want to install? (enter the number): "
    options=("ProtonVPN" "Mullvad")

    select vpn_choice in "${options[@]}"; do
        case $vpn_choice in
            "ProtonVPN")
                vpn_name="ProtonVPN"
                vpn_file="$main_dir/vpn_and_firewall/vpn.dmg"
                break
                ;;
            "Mullvad")
                vpn_name="Mullvad VPN"
                vpn_file="$main_dir/vpn_and_firewall/vpn.pkg"
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
        hdiutil attach "$vpn_file"
        rsync -a "/Volumes/ProtonVPN/ProtonVPN.app" "/Applications/"
        sleep 5
        hdiutil detach "/Volumes/ProtonVPN/"
        sleep 3
    elif [ "$vpn_name" == "Mullvad VPN" ]; then
        installer -package "$vpn_file" -target /
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

installVpn
