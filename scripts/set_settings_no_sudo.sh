#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Set some important settings without sudo
function setSettings(){
    function configureSettings() {
        local prompt="$1"
        shift  # Remove the prompt from the list of commands
        local commands=("$@")

        echo -e "${BOLD}$prompt${NC}"

        local success=true

        # Run each command in the array
        for cmd in "${commands[@]}"; do
            eval "$cmd"
            # Check the exit status
            if [ $? -ne 0 ]; then
                success=false
                break
            fi
        done

        if [ "$success" = true ]; then
            echo -e "${GREEN}Successful${NC}\n"
        else
            echo -e "${RED}Failed${NC}\n"
        fi
    }

    disableHandoff=(
        "defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool no"
        "defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool no"
    )



    # Run the configureSettings function for each set of commands
    configureSettings "Disable Handoff" "${disableHandoff[@]}"
}

setSettings
