#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
NC='\033[0m'

# Remove unneccessary features
function disableFeatures() {
    echo -e "\nWe will disable a few unneccessary features. \nYou will be asked if you want a feature to be disabled."
    echo -e "\nHit ${GREEN}ENTER${NC} to start"
    read

    function runCommand() {
        local prompt="$1"
        local command_to_run="$2"
        local choice

        while true; do
            echo -en "${BOLD}$prompt${NC} (y/n): "
            read choice

            if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
                echo "Running the command..."
                # Run the specified command
                eval "$command_to_run"
                echo -e "${GREEN}Successful${NC}\n"
                break
            elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
                echo -e "Exiting without running the command.\n"
                break
            else
                echo "Invalid choice. Please enter 'y' or 'n'."
            fi
        done
    }

    # Run Commands
    disable_spotlight="
    mdutil -i off / > /dev/null 2>&1 &&
    mdutil -E"

    disable_siri="
    defaults write com.apple.assistant.support 'Assistant Enabled' -bool false &&
    defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3 &&
    launchctl disable 'user/$UID/com.apple.assistantd' > /dev/null 2>&1 &&
    launchctl disable 'gui/$UID/com.apple.assistantd' > /dev/null 2>&1 &&
    launchctl disable 'system/com.apple.assistantd' > /dev/null 2>&1 &&
    launchctl disable 'user/$UID/com.apple.Siri.agent' > /dev/null 2>&1 &&
    launchctl disable 'gui/$UID/com.apple.Siri.agent' > /dev/null 2>&1 &&
    launchctl disable 'system/com.apple.Siri.agent' > /dev/null 2>&1 &&
    defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True &&
    defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0 &&
    defaults write com.apple.Siri 'StatusMenuVisible' -bool false &&
    defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true &&
    defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2"

    disable_airdrop="
    defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"

    disable_remote_connections="
    echo 'yes' | systemsetup -setremotelogin off &&
    launchctl disable 'system/com.apple.tftpd' &&
    defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true &&
    launchctl disable system/com.apple.telnetd &&
    cupsctl --no-share-printers &&
    cupsctl --no-remote-any &&
    cupsctl --no-remote-admin"

    disable_gatekeeper="
    spctl --master-disable"

    disable_power_options="
    pmset -a tcpkeepalive 0 > /dev/null 2>&1 &&
    pmset -a powernap 0 > /dev/null 2>&1 &&
    pmset -a networkoversleep 0 > /dev/null 2>&1 &&
    pmset -a ttyskeepawake 0 > /dev/null 2>&1 &&
    pmset -a womp 0"

    runCommand "Do you want to Disable Spotlight? (you can install an alternative like Raycast/Alfred later)" "$disable_spotlight"
    runCommand "Do you want to Disable Siri? (recommended)" "$disable_siri"
    runCommand "Do you want to Disable AirDrop? (recommended)" "$disable_airdrop"
    runCommand "Do you want to Disable Remote Connections? (recommended - it can take a few seconds to complete)" "$disable_remote_connections"
    runCommand "Do you want to Disable Gatekeeper (recommended)" "$disable_gatekeeper"
    runCommand "Do you want to Disable Power Options (recommended)" "$disable_power_options"
}

disableFeatures
