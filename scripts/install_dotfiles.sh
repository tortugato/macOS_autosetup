#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
main_dir=$(dirname "$(dirname "$(realpath "$0")")")
dest_dir="/Users/$USER/.config/"
mkdir "/Users/$USER/.config/"
# Cleanup Script Installation
function installDotfiles(){

    echo -e "\nMake sure to include all your dotfiles in ${BOLD}"$main_dir/config/dotfiles/"${NC}\n"
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read

    # Exclude patterns
    exclude_patterns=(.DS_Store dotfiles note.md)

    # Reset success flag
    success=true

    # Iterate over files and directories
    for item in "$main_dir"/config/dotfiles/*; do
        # Extract the base name of the item
        base_name=$(basename "$item")

        # Check if the item should be excluded
        if [[ ! " ${exclude_patterns[@]} " =~ " $base_name " ]]; then

            # Check if the file is the zshrc
            if [ "$base_name" = "zshrc" ]; then
                cp -f "$main_dir/config/dotfiles/zshrc" ~/.zshrc
                source ~/.zshrc
            else
            # Copy files and directories to the destination
                cp -r "$item" "$dest_dir"

                # Check for errors
                if [ $? -ne 0 ]; then
                    echo "${RED}Error copying $item to $dest_dir${NC}"
                    success=false
                fi
            fi
        fi
    done

    if [ "$success" = true ]; then
        echo -e "${GREEN}Successfully${NC} copied all dotfiles.\n"
    else
        echo -e "${RED}Failed${NC} to copy all dotfiles. Try again manually.\n"
    fi
}

installDotfiles
