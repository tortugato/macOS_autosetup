#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")

# Universal download function
function downloadFirewall() {
    local download_url=$1

    # Step 1: Download the asset
    curl -L -o firewall.dmg "$download_url"

    # Step 2: Move the asset to the specified directory
    mv firewall.dmg "${main_dir}/config/vpn_and_firewall/firewall.dmg"
}

# Function to install a Firewall
function installFirewall() {
    echo -e "\nNext we will install a Firewall."

    # Display the menu to choose which firewall to install
    echo -e "\nWhich Firewall do you want to install? (enter the number): "
    options=("LittleSnitch" "LuLu")

    select firewall_choice in "${options[@]}"; do
        case $firewall_choice in
            "LittleSnitch")
                # Set Download URL for Little Snitch
                download_url="https://www.obdev.at/downloads/littlesnitch/legacy/LittleSnitch-5.7.6.dmg"

                # Call universal download function
                downloadFirewall "$download_url"

                firewall_name="Little Snitch"
                firewall_install_note="\n1) Uncheck Apple Services and iCloud Services during the last step of installation \n2) Allow Notifications and the System Extension by LittleSnitch \n3) Click on DemoMode as we won't be able to activate the LittleSnitch license now \n4) Turn on Alert Mode (not Silent Mode) \n5) After the initial setup open Little Snitch, click on File -> Restore from Backup and select the provided LittleSnitch.xpl file."
                break
                ;;
            "LuLu")
                # Set Download URL for LuLu
                download_url="https://github.com/objective-see/LuLu/releases/download/v2.6.3/LuLu_2.6.3.dmg"

                # Call universal download function
                downloadFirewall "$download_url"

                firewall_name="LuLu"
                firewall_install_note="\n1) Uncheck Allow Apple Programs and Allow Already Installed Applications during the installation \n2) Allow Notifications and the System Extension by LuLu"
                break
                ;;
            *)
                echo "Invalid option, please choose 1 or 2."
                ;;
        esac
    done

    # Check if firewall.dmg file is in folder
    while true; do
        if [ ! -e "$main_dir/config/vpn_and_firewall/firewall.dmg" ]; then
            clear
            echo -e "${RED}Something went wrong. Not all files required for this setup are in $main_dir/vpn_and_firewall/.${NC}"
            echo "Please download the firewall file manually and place it in $main_dir/vpn_and_firewall/ as firewall.dmg"
            read -p "Press Enter to retry detecting the file or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
            exit 1
            fi
        else
            break  # Exit the loop if files are present
        fi
    done

    echo -e "\nPlease make sure to follow the instructions by the $firewall_name installer carefully! \n"
    printf "%${width}s\n" | tr ' ' '-'

    # Start the installation
    echo -e "\nHit ${GREEN}ENTER${NC} to start the installation"
    read

    # Mount the DMG
    hdiutil attach "$main_dir/config/vpn_and_firewall/firewall.dmg"

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
    hdiutil detach "${app_name}/"
    sleep 3

    # Hit enter to setup
    echo -e "\n${GREEN}Successfully installed $firewall_name${NC}."
    echo -e "\nHit ${GREEN}ENTER${NC} to start the setup!"
    read

    #Open the firewall
    open "/Applications/${firewall_name}.app"

    echo -e "\n${RED}Please follow the setup process for $firewall_name before continuing.${NC}"
    echo -e "\n${BOLD} $firewall_install_note"
    echo -e "\nHit ${GREEN}ENTER${NC} when you have finished setting up $firewall_name"
    read
}

installFirewall
