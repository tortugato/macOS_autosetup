#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Set some important settings with sudo
function setSettings(){
    sleep 1
    echo -e "${BOLD}Settings some important settings...${NC}"

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

    # Commands for activating firewall
    activateFirewall=(
        "/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on --setallowsigned off --setallowsignedapp off --setloggingmode off --setstealthmode on --setglobalstate on"
        "/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on"
    )

    setTimeFromNTP=(
        "systemsetup -setnetworktimeserver pool.ntp.org"
        "systemsetup -setusingnetworktime on"
    )

    configurePassword=(
        "defaults write NSGlobalDomain RetriesUntilHint -int 0"
    )

    showNameAndPassword=(
        "defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool yes"
    )

    disableAnalytics=(
        "defaults write '/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist' AutoSubmit -bool no"
        "chmod 644 '/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist'"
        "chgrp admin '/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist'"
    )

    disableAdvertising=(
        "/usr/bin/sudo -u $USER /usr/bin/defaults write '$HOME/Library/Preferences/com.apple.Adlib.plist' allowApplePersonalizedAdvertising -bool false"
    )

    disableMetadataFiles=(
        "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
        "defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true"
    )

    disableAutomaticUpdates=(
    "defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false"
    "defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool false"
    "defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool false"
    "defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false"
    "defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool false"
    )

    # Run the configureSettings function for each set of commands
    configureSettings "Activating Firewall" "${activateFirewall[@]}"
    configureSettings "Check Firewall Settings" "${checkFirewallSettings[@]}"
    configureSettings "Set Time from NTP" "${setTimeFromNTP[@]}"
    configureSettings "Don't show Password Hints on Lockscreen" "${configurePassword[@]}"
    configureSettings "Show name and password field instead of user list on lockscreen" "${showNameAndPassword[@]}"
    configureSettings "Disable Analytics" "${disableAnalytics[@]}"
    configureSettings "Disable Advertising" "${disableAdvertising[@]}"
    configureSettings "Disable Metadata Files" "${disableMetadataFiles[@]}"
    configureSettings "Disable Automatic Updates" "${disableAutomaticUpdates[@]}"

}

setSettings
