#!/bin/bash

# Function to run commands with a prompt
function runFunctions() {
    local prompt="$1"
    local command_to_run="$2"
    local section_title="$3"
    local valid_choice=false

    # Print section heading
    printSectionHeading "$section_title"

    while [ "$valid_choice" == false ]; do
        echo -n "$prompt (y/n): "
        read -r choice

        if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
            # Run the specified command
            eval "$command_to_run"
            valid_choice=true

            # Connect to VPN prompt only when VPN was installed
            if [[ "$section_title" == "Install VPN" ]]; then
                export VPN_INSTALLED=true
            elif [[ "$section_title" == "Install Firewall" ]]; then
                export FIREWALL_INSTALLED=true
            fi
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "Continuing without running the function.\n"
            valid_choice=true
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    done
}

function printSectionHeading() {
    local title="$1"
    title_length=$(( ${#title} + 4 ))  # Account for additional characters

    # Get terminal width
    local terminal_width=$(tput cols)
    length_to_fill=$(( terminal_width - title_length ))

    # Create a string of '-' characters of length length_to_fill
    local fill_characters=$(printf '─%.0s' $(seq 1 $length_to_fill))

    # Print the pattern
    printf "─ \033[1m%s\033[0m \033[1m%s\033[0m\n" "$title" "$fill_characters"
}

# Clear before start
clear

# Ask the user for online or offline install
offline_install=true
while true; do
    echo -n "Do you want to perform an online install? (y/n): "
    read -r install_choice
    if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
        offline_install=false
        break
    elif [[ "$install_choice" == "n" || "$install_choice" == "N" ]]; then
        offline_install=true
        break
    else
        echo "Invalid choice. Please enter 'y' or 'n'."
    fi
done

# Set the path suffix based on the install method
if [ "$offline_install" == true ]; then
    path_suffix="offline"
else
    path_suffix="online"
fi

clear

# Check internet and exit if available
if [ "$offline_install" == true ]; then
    printSectionHeading "Turning Internet Connection off"
else
    printSectionHeading "Turning Internet Connection on"
fi
sudo ./scripts/${path_suffix}/check_internet.sh

# Introduction
printSectionHeading "Introduction"
./scripts/introduction.sh

# Check FileVault
printSectionHeading "Turning FileVault On"
sudo ./scripts/check_filevault.sh

# Install Scripts
printSectionHeading "Installing Scripts"
sudo ./scripts/install_scripts.sh

# Set Settings
printSectionHeading "Setting important settings"
sudo ./scripts/set_settings_sudo.sh
./scripts/set_settings_no_sudo.sh

# Run functions with prompts
runFunctions "Do you want to Disable Features? (recommended)" "sudo ./scripts/disable_functions.sh" "Disable Features"
runFunctions "Do you want to Install a Firewall? (highly recommended)" "sudo ./scripts/${path_suffix}/install_firewall.sh" "Install Firewall"
runFunctions "Do you want to Install a VPN? (recommended)" "sudo ./scripts/${path_suffix}/install_vpn.sh" "Install VPN"

# Connect to internet only if offline install was chosen
if [ "$offline_install" == true ]; then
    printSectionHeading "Connect to Internet"
    ./scripts/${path_suffix}/connect_to_internet.sh
fi

# Check if the user chose to install the VPN
if [ "$VPN_INSTALLED" == "true" ]; then
    printSectionHeading "Connect to VPN"
    ./scripts/connect_to_vpn.sh
fi

# Install homebrew and some necessary packages
printSectionHeading "Homebrew"
if [[ "$FIREWALL_INSTALLED" == "true" && -e "/Applications/Little Snitch.app" ]]; then
    ./scripts/homebrew_ls.sh
else
    ./scripts/homebrew.sh
fi

# Clean Up the Look
printSectionHeading "Cleaning up Look"
./scripts/clean_look.sh

# Install Dotfiles
runFunctions "Do you want to install dotfiles?" "./scripts/install_dotfiles.sh" "Install Dotfiles"

# Removing Admin Privileges
printSectionHeading "Removing Admin Privileges"
sudo ./scripts/remove_sudo.sh

# Reboot on finish
printSectionHeading "Script Finished!"
./scripts/reboot_on_finish.sh
