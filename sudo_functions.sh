#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the path for the script directory
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")

# Clear the terminal before use
clear

# -----------------------------------------------------------------------------------------
# Requirements functions
# Check if internet connection is available
function checkInternetConnectionOff() {
    if ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
        echo "Internet connection is available."
        echo -e "${RED}Please turn your internet connection off and restart the script.${NC}"
        exit 1
    fi
}

# Check if Filevault is on
function checkFilevault(){
    filevault_status=$(fdesetup status)
    if [[ "$filevault_status" != "FileVault is On." ]]; then
        echo "FileVault is not enabled. Enabling FileVault..."
        fdesetup enable
        echo -e "\n${RED}Please save the Recovery Key in a secure location, e.g. your password manager.${NC} 
        \nHit ${GREEN}ENTER${NC} to continue"
        read
    fi
}

# -----------------------------------------------------------------------------------------
# Introduction test
function introduction(){
    clear
    echo -e "${BOLD}WELCOME TO THE SETUP${NC}"
    echo -e "This setup script aims to set up MacOS in the most private and secure way possible. \nThis script performs steps that I consider necessary and unavoidable to use MacOS privately and securely. \nI will continue to improve this script, so please keep an eye on the Github repository for possible changes. \nIf you have any suggestions for improvement, please post an issue to Github, I will try to take care of it as soon as possible.
    \n\nLets get started. Here is an overview of the steps this script will guide you through.
    \n1) Deactivation of unneccessary features
    \n2) Installation of helpful scripts
    \n3) Setting a generic Hostname & MacAddress Randomizer
    \n4) Changing some basic Settings
    \n5) Cleaning up the look of MacOs
    \n6) Installation of a Firewall
    \n7) Installation of a VPN
    \n8) Installation of other helpful software"

    echo -e "\n\nHit ${GREEN}ENTER${NC} to continue or ${RED}ctrl-c${NC} to abort."
    read 
    clear

    echo -e "After the initial setup of your system according to the ReadME we will now configure the macOS system for privacy and security."
    echo -e "\nHit ${GREEN}ENTER${NC} to continue"
    read   
}

# -----------------------------------------------------------------------------------------
# Cleanup Script Installation
function installScripts(){
    clear
    echo -e "${BOLD}Installing Scripts...${NC}"

    function installScripts() {
        local success=true
        local prompt="$1"
        local command_to_run="$2"

        echo -e "${BOLD}$prompt${NC}"
        echo -e "Running the command..."
        eval "$command_to_run"
           
        if [ $? -ne 0 ]; then
            success=false
        fi
    
        if [ "$success" = true ]; then
            echo -e "${GREEN}Successful${NC}\n"
        else
            echo -e "${RED}Failed${NC}\n"
        fi
    }

    installCleanupScript="
    mkdir -p /usr/local/bin &&
    cp '$script_dir/installscripts/cleanup' '/usr/local/bin/cleanup'
    "

    installAppCleanerScript="
    cp '$script_dir/installscripts/app-cleaner' '/usr/local/bin/app-cleaner'
    "

    installMacaddressRandomizer="
    mkdir -p /usr/local/sbin &&
    chown ${USER}:admin /usr/local/sbin &&
    touch ~/.zshrc &&
    echo 'export PATH=$PATH:/usr/local/sbin' >> ~/.zshrc &&
    source ~/.zshrc &&
    cp '$script_dir/installscripts/spoof.sh' '/usr/local/sbin/spoof.sh' &&
    chmod +x /usr/local/sbin/spoof.sh &&
    cp '$script_dir/installscripts/local.spoof.plist' '/Library/LaunchDaemons/local.spoof.plist'
    "

    installLogoutHook="
    cp '$script_dir/installscripts/spoof-hook.sh' '/usr/local/sbin/spoof-hook.sh' &&
    chmod +x /usr/local/sbin/spoof-hook.sh
    defaults delete com.apple.loginwindow LogoutHook
    defaults write com.apple.loginwindow LogoutHook '/usr/local/sbin/spoof-hook.sh'
    defaults read com.apple.loginwindow
    "

    installScripts "Installing Cleanup Script" "$installCleanupScript"
    installScripts "Installing App Cleaner Script" "$installAppCleanerScript"
    installScripts "Installing Mac Address Randomizer" "$installMacaddressRandomizer"
    installScripts "Installing Logout Hook" "$installLogoutHook"
}

# -----------------------------------------------------------------------------------------
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

    # Commands for activating firewall
    activateFirewall=(
        "/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on --setallowsigned off --setallowsignedapp off --setloggingmode off --setstealthmode on --setglobalstate on"
    )

    # Commands for checking firewall settings manually
    checkFirewallSettings=(
        "echo -e '\n${RED}Please double-check the firewall settings in System Settings -> Network -> Firewall -> Options.${NC}'"
        "echo 'The firewall should be enabled, Stealth Mode should be enabled, and 'Block all incoming connections' should be true.'"
        "open '/System/Applications/System Settings.app'"
        "echo -e 'Hit ${GREEN}ENTER${NC} when you check the settings'"
        "read"
        "killall -9 'System Settings'"
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

    disableHandoff=(
        "defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool no"
        "defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool no"
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

    # Run the configureSettings function for each set of commands
    configureSettings "Activating Firewall" "${activateFirewall[@]}"
    configureSettings "Check Firewall Settings" "${checkFirewallSettings[@]}"
    configureSettings "Set Time from NTP" "${setTimeFromNTP[@]}"
    configureSettings "Don't show Password Hints on Lockscreen" "${configurePassword[@]}"
    configureSettings "Show name and password field instead of user list on lockscreen" "${showNameAndPassword[@]}"
    configureSettings "Disable Handoff" "${disableHandoff[@]}"
    configureSettings "Disable Analytics" "${disableAnalytics[@]}"
    configureSettings "Disable Advertising" "${disableAdvertising[@]}"
    configureSettings "Disable Metadata Files" "${disableMetadataFiles[@]}"

}

# -----------------------------------------------------------------------------------------
# Remove unneccessary features
function disableFeatures() {
    clear
    echo -e "We will disable a few unneccessary features. \nYou will be asked if you want a feature to be disabled."
    echo -e "\nHit ${GREEN}ENTER${NC} to start"
    read

    function runCommand() {
        local prompt="$1"
        local command_to_run="$2"
        echo -en "${BOLD}$prompt${NC} (y/n): "
        read choice

        if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
            echo "Running the command..."
            # Run the specified command
            eval "$command_to_run"
            echo -e "${GREEN}Successfull${NC}\n"
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "Exiting without running the command. \n"
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    }

    # Run Commands
    disable_spotlight="
    mdutil -i off && 
    mdutil -E"

    disable_siri="
    defaults write com.apple.assistant.support 'Assistant Enabled' -bool false &&
    defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3 &&
    launchctl disable 'user/$UID/com.apple.assistantd' &&
    launchctl disable 'gui/$UID/com.apple.assistantd' &&
    launchctl disable 'system/com.apple.assistantd' &&
    launchctl disable 'user/$UID/com.apple.Siri.agent' &&
    launchctl disable 'gui/$UID/com.apple.Siri.agent' &&
    launchctl disable 'system/com.apple.Siri.agent' &&
    defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True &&
    defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0 &&
    defaults write com.apple.Siri 'StatusMenuVisible' -bool false &&
    defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true &&
    defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2"

    disable_airdrop="
    defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"

    disable_remote_connections="
    systemsetup -setremotelogin off &&
    launchctl disable 'system/com.apple.tftpd' &&
    defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true &&
    launchctl disable system/com.apple.telnetd &&
    cupsctl --no-share-printers &&
    cupsctl --no-remote-any &&
    cupsctl --no-remote-admin"

    disable_gatekeeper="
    spctl --master-disable"

    disable_power_options="
    pmset -a tcpkeepalive 0 &&
    pmset -a powernap 0 &&
    pmset -a networkoversleep 0 &&
    pmset -a ttyskeepawake 0 &&
    pmset -a womp 0"

    runCommand "Do you want to Disable Spotlight? (you can install an alternative like Raycast/Alfred later)" "$disable_spotlight"
    runCommand "Do you want to Disable Siri? (recommended)" "$disable_siri"
    runCommand "Do you want to Disable AirDrop? (recommended)" "$disable_airdrop"
    runCommand "Do you want to Disable Remote Connections? (recommended, but it can take a few seconds to complete)" "$disable_remote_connections"
    runCommand "Do you want to Disable Gatekeeper (recommended)" "$disable_gatekeeper"
    runCommand "Do you want to Disable Power Options (recommended)" "$disable_power_options"
}


# -----------------------------------------------------------------------------------------
# Installation of a Firewall
function installFirewall(){
    echo -e "Next we will install a Firewall."

    # Check if firewall.dmg file is in folder
    while true; do
        if [ ! -e "$script_dir/vpn_and_firewall/firewall.dmg" ]; then
            clear
            echo -e "${RED}Not all files required for this setup are in $script_dir/vpn_and_firewall/.${NC}"
            echo "Please double-check to include the firewall file. (firewall.dmg)"
            read -p "Press Enter to retry or 'q' to quit: " input
            if [ "$input" == "q" ]; then
                echo "Exiting installation."
            exit 1
            fi
        else
            clear
            break  # Exit the loop if files are present
        fi
    done

    echo -e "Hit ${GREEN}ENTER${NC} to start the installation"
    read

    # Display the menu to choose which firewall to install
    echo -e "\nWhich Firewall do you want to install? (enter the number): "
    options=("LittleSnitch" "LuLu")

    select firewall_choice in "${options[@]}"; do
        case $firewall_choice in
            "LittleSnitch")
                firewall_name="Little Snitch"
                firewall_install_note="\n1) Uncheck Apple Services and iCloud Services during the last step of installation \n2) Allow Notifications and the System Extension by LittleSnitch \n3) Click on DemoMode as we won't be able to active the LittleSnitch license now \n4) Turn on Alert Mode (not Silent Mode) \n5) After the initial setup open Little Snitch, click on File -> Restore from Backup and select the provided LittleSnitch.xpl file."
                break
                ;;
            "LuLu")
                firewall_name="LuLu"
                firewall_install_note="\n1) Uncheck Allow Apple Programs and Allow Already Installed Applications during the installation \n2) Allow Notifications and the System Extension by LuLu"
                break
                ;;
            *)
                echo "Invalid option, please choose 1 or 2."
                ;;
        esac
    done

    echo -e "\nPlease make sure to follow the instructions by the $firewall_name installer carefully! \n${BOLD}Make sure: $firewall_install_note ${NC}"
    printf "%${width}s\n" | tr ' ' '-' 

    # Start the installation
    echo -e "\nHit ${GREEN}ENTER${NC} to start the installation (you will be prompted for your password)"
    read

    # Mount the DMG
    hdiutil attach "$script_dir/vpn_and_firewall/firewall.dmg"

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

    #Open the firewall
    open "/Applications/${firewall_name}.app"
    clear

    echo -e "${GREEN}The Firewall was successfully installed.${NC}"
    echo -e "\n${RED}Please follow the setup process for LittleSnitch before continuing.${NC}"
    echo -e "\n${BOLD}REMINDER: $firewall_install_note"
    echo -e "\nHit ${GREEN}ENTER${NC} when you are finished setting up $firewall_name"
    read 
}

# -----------------------------------------------------------------------------------------
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
                vpn_file="$script_dir/vpn_and_firewall/vpn.dmg"
                break
                ;;
            "Mullvad")
                vpn_name="Mullvad VPN"
                vpn_file="$script_dir/vpn_and_firewall/vpn.pkg"
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

# -----------------------------------------------------------------------------------------
# Turn on network connection
function turnNetworkOn() {
    clear
    echo -e "${GREEN}You will now be able to turn your internet connection on. \nPlease connect to Wi-Fi or Ethernet now.${NC}"
    echo -e "\nHit ${GREEN}ENTER${NC} when your internet is connected."
    read 

    while true; do
        if ! ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
            clear
            echo "Internet connection is not available."
            echo -e "${RED}Please turn your internet connection on.${NC}"
            echo -e "\nHit ${GREEN}ENTER${NC} when your internet is connected."
            read 
        else
            break
        fi
    done
}

# -----------------------------------------------------------------------------------------
# Run the Script
function runFunctions() {
    local prompt="$1"
    local command_to_run="$2"
    local valid_choice=false

    while [ "$valid_choice" == false ]; do
        
        echo -n "$prompt (y/n): "
        read -r choice

        if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
            # Run the specified command
            eval "$command_to_run"
            clear
            valid_choice=true
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "Continuing without running the function. \n"
            valid_choice=true
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    done
}

# Run functions 
# Checks first
checkInternetConnectionOff
checkFilevault


# Introduction
introduction

# Install Scripts
installScripts

# Configure Settings
setSettings

# Optional but recommended installs
runFunctions "Do you want to Disable Features? (recommended)" "disableFeatures"
runFunctions "Do you want to Install a Firewall? (highly recommended)" "installFirewall"
runFunctions "Do you want to Install a VPN? (recommended)" "installVpn"

# Internet Connection Things
turnNetworkOn