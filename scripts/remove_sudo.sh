#!/bin/bash

# Set colors to the accroding variables
BOLD='\033[1m'
NC='\033[0m'

# Function to create a new admin user
function createAdminUser() {
    # Prompt for new admin username
    echo -e "Creating admin user: ${BOLD}adm${NC}"
    shell="/bin/zsh"
    newUsername="adm"
    realName="$newUsername"

    # Prompt for new admin password and hide input
    read -sp "Enter the new admin password: " newPassword

    # Get the next available UniqueID
    uniqueID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -n 1)
    uniqueID=$((uniqueID + 1))

    # Create the new admin user with specified parameters
    dscl . -create /Users/"$newUsername"
    dscl . -create /Users/"$newUsername" UserShell "$shell"
    dscl . -create /Users/"$newUsername" RealName "$realName"
    dscl . -create /Users/"$newUsername" UniqueID "$uniqueID"
    dscl . -create /Users/"$newUsername" PrimaryGroupID 20
    dscl . -create /Users/"$newUsername" NFSHomeDirectory "/Users/$newUsername"
    dscl . -passwd "/Users/$newUsername" "$newPassword"
    dscl . -append /Groups/admin GroupMembership "$newUsername"

    echo -e "\nCreated admin user $newUsername\n"
}


# Function to check admin status without sudo
function checkAdminStatus() {
    if groups $USER | grep -q -w admin; then
        adminStatus="Is admin"
    else
        adminStatus="Not admin"
    fi
}

# Main function to manage admin privileges
function manageAdmin() {
    # Check if the original user is an admin
    checkAdminStatus
    if [ "$adminStatus" == "Is admin" ]; then
        echo -e "You are currently an admin user."
        echo -e "Disabling Administrator Privileges and creating a new admin user."

        # Create new admin
        createAdminUser

        # Demote current user to standard user
        dseditgroup -o edit -d "$SUDO_USER" -t user admin
        echo -e "\nDemoted user $SUDO_USER\n"
        echo -e "\n${BOLD}Since you are not an admin anymore you can use 'sufo COMMAND' to run commands with sudo privileges.${NC}\n"

    else
        echo -e "You are not currently an admin user. Skipping this step..."
    fi
}

# Run the main function
manageAdmin
