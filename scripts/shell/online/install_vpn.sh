#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")")
# Universal download function for VPN
function downloadVPN() {
    local download_url=$1
    local vpn_file=$2

    # Download the asset to the vpn_and_firewall directory
    curl -L -o "${main_dir}/resources/vpn_and_firewall/$vpn_file" "$download_url"

}

# Function to install VPN
function installVpn(){
    echo -e "\nNext we will install a VPN."

    # Display the menu to choose which VPN to install
    echo -e "\nWhich VPN do you want to install? (enter the number):\n"
    options=("ProtonVPN" "Mullvad")

    select vpn_choice in "${options[@]}"; do
        case $vpn_choice in
            "ProtonVPN")
                # Set Download URL and VPN file name for ProtonVPN
                download_url="https://vpn.protondownload.com/download/macos/4.8.0/ProtonVPN_mac_v4.8.0.dmg"
                vpn_file="vpn.dmg"  # Set the file name to vpn.dmg

                # Call universal download function
                downloadVPN "$download_url" "$vpn_file"

                vpn_name="ProtonVPN"
                vpn_install_note="\n1) Open the downloaded .dmg file and follow the installation instructions."
                break
                ;;
            "Mullvad")
                # Set Download URL and VPN file name for Mullvad
                download_url="https://mullvad.net/de/download/app/pkg/latest"
                vpn_file="vpn.pkg"  # Set the file name to vpn.pkg

                # Call universal download function
                downloadVPN "$download_url" "$vpn_file"

                vpn_name="Mullvad VPN"
                vpn_install_note="\n1) Open Terminal and navigate to the directory where vpn.pkg is located."
                vpn_install_note+="\n2) Run 'sudo installer -pkg vpn.pkg -target /'."
                break
                ;;
            *)
                echo "Invalid option, please choose 1 or 2."
                ;;
        esac
    done

    # Check if the selected VPN file exists
    while true; do
        if [ ! -e "$main_dir/resources/vpn_and_firewall/$vpn_file" ]; then
            clear
            echo -e "${RED}Something went wrong. Not all files required for this setup are in $main_dir/resources/vpn_and_firewall/.${NC}"
            echo "Please download the vpn file manually and place it in $main_dir/resources/vpn_and_firewall/ as $vpn_file"
            read -p "Press Enter to retry detecting the file or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
            exit 1
            fi
        else
            break  # Exit the loop if VPN file is present
        fi
    done

    # Continue with installation based on the selected VPN
    echo -e "\nInstalling $vpn_name ..."
    if [ "$vpn_name" == "ProtonVPN" ]; then
        hdiutil attach "$main_dir/resources/vpn_and_firewall/vpn.dmg"
        rsync -a "/Volumes/ProtonVPN/ProtonVPN.app" "/Applications/"
        sleep 5
        hdiutil detach "/Volumes/ProtonVPN/"
        sleep 3
    elif [ "$vpn_name" == "Mullvad VPN" ]; then
        installer -package "$main_dir/resources/vpn_and_firewall/vpn.pkg" -target /
    fi


    echo -e "${GREEN}The VPN was successfully installed.${NC}"
}

installVpn
