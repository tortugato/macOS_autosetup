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

    # Get terminal width
    local terminal_width=$(tput cols)

    # Calculate the padding for the sides
    local padding=$(( (terminal_width - ${#title} - 4) / 2 ))

    # Print the pattern
    printf "%${terminal_width}s\n" | tr ' ' '#'
    printf "%${padding}s%s%${padding}s\n" "" "$title" ""
    printf "%${terminal_width}s\n" | tr ' ' '#'
}

# Clear before start
clear

# Check internet and exit if available
printSectionHeading "Turning Internet Connection off"
sudo ./scripts/check_internet.sh

# Check FileVault
printSectionHeading "Turning FileVault On"
sudo ./scripts/check_filevault.sh

# Introduction
printSectionHeading "Introduction"
./scripts/introduction.sh

# Install Scripts
printSectionHeading "Installing Scripts"
sudo ./scripts/install_scripts.sh

# Set Settings
printSectionHeading "Setting important settings"
sudo ./scripts/set_settings_sudo.sh
./scripts/set_settings_no_sudo.sh

# Run functions with prompts
runFunctions "Do you want to Disable Features? (recommended)" "sudo ./scripts/disable_functions.sh" "Disable Features"
runFunctions "Do you want to Install a Firewall? (highly recommended)" "sudo ./scripts/install_firewall.sh" "Install Firewall"
runFunctions "Do you want to Install a VPN? (recommended)" "sudo ./scripts/install_vpn.sh" "Install VPN"

# Turn internet on
printSectionHeading "Connect to Internet"
./scripts/connect_to_internet.sh

# Connect to VPN
printSectionHeading "Connect to VPN"
./scripts/connect_to_vpn.sh

# Install homebrew and some neccessary packages
printSectionHeading "Homebrew"
./scripts/homebrew.sh

# Clean Up the Look
printSectionHeading "Cleaning up Look"
./scripts/clean_look.sh

# Install Dotfiles
runFunctions "Do you want to install dotiles?" "./scripts/install_dotfiles.sh" "Install Dotfiles"

# Reboot on finish
printSectionHeading "Script Finished!"
sudo ./scripts/reboot_on_finish.sh
