#!/bin/bash

# Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Function to install Homebrew
installHomebrew() {

    # Installation
    while true; do
        if ! ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
            echo -e "Please check your internet connection! Press ${GREEN}ENTER${NC} to retry or ${RED}CTRL+C${NC} to exit"
            read
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
                exit 1
            fi
        else
            break
        fi
    done
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


# Function to update Homebrew and install programs
updateAndInstall() {
    echo -e "\n${BOLD}Turning Brew Analytics off${NC}"
    /opt/homebrew/bin/brew analytics off

    echo -e "\n${BOLD}Updating Brew${NC}"
    /opt/homebrew/bin/brew update

    echo -e "\n${BOLD}Installing the Security Brewfile${NC}"
    /opt/homebrew/bin/brew bundle --file "$main_dir/resources/brewfiles/Brewfile_security"
}

# Function to check for and install a custom Brewfile
installCustomBrewfile() {
    brew_file="$main_dir/resources/brewfiles/Brewfile_custom"
    while true; do
        if [ ! -e "$brew_file" ]; then
            clear
            echo -e "${RED}The required Brew file ('Brewfile_custom') is missing at $brew_file.${NC}"
            echo "Please make sure to include the correct Brewfile before proceeding."
            read -p "Press Enter to retry or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
                exit 1
            fi
        else
            break  # Exit the loop if Brewfile is present
        fi
    done

    /opt/homebrew/bin/brew bundle --file "$brew_file"
}

# Main script
main() {
    # Getting the main directory
    main_dir=$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")

    # Install Homebrew
    installHomebrew || exit 1

    # Update and install programs
    updateAndInstall

    # Ask to install custom Brew file
    echo -e "${BOLD}\nDo you want to install a custom Brewfile? (y/n): ${NC}"
    read -r choice

    if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
        installCustomBrewfile
        echo "Installation completed."
    else
        echo "Continuing without installing a custom Brewfile."
    fi
}

# Run the main function
main
