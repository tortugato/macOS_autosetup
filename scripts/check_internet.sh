#!/bin/bash

# Set colors to the accroding variables
RED='\033[0;31m'
NC='\033[0m'

# Get the list of all network interfaces
all_interfaces=$(networksetup -listallnetworkservices)

# Requirements functions
# Check if internet connection is available
function checkInternetConnectionOff() {
    if ping -q -c 1 -W 1 proton.me > /dev/null 2>&1; then
        echo "Internet connection is available."
        echo "Trying to disable internet connection automatically."

        # Loop through each interface
        while IFS= read -r interface; do
            # Exclude lines with the description
            if [[ ! "$interface" =~ An\ asterisk\ \(\*\) ]]; then
                echo "Disabling network interface: $interface"
                networksetup -setnetworkserviceenabled "$interface" off
            fi
        done <<< "$all_interfaces"

        echo "Network interfaces disabled."
        sleep 2
    fi
}

checkInternetConnectionOff
