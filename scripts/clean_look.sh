#!/bin/bash

# Set colors to the corresponding variables
GREEN='\033[0;32m'
NC='\033[0m'

function cleanLook() {
    local valid_choice=false
    prompt="Do you want to clean up the look? You can see pictures of the after look in the GitHub repo."

    # Display prompt and get user input
    echo -e "$prompt"

    while [ "$valid_choice" == false ]; do
        # Prompt for user input
        read -rp "Do you want to clean up the look? (y/n): " choice

        if [[ "$choice" =~ ^[Yy]$ || -z "$choice" ]]; then
            # Run the specified commands

            # Dock
            echo -e "\nChanging Dock Look..."
            # Remove existing applications and folders from the Dock
            defaults write com.apple.dock persistent-apps -array
            defaults write com.apple.dock persistent-others -array
            # Disable recent applications
            defaults write com.apple.dock "show-recents" -bool false
            # Add Launchpad and Terminal back to the Dock
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Launchpad.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
            defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
            # Decrease Dock size
            defaults write com.apple.dock tilesize -integer 40
            # Minimize Dock effects
            defaults write com.apple.dock mineffect "scale"
            defaults write com.apple.dock minimize-to-application -bool true
            defaults write com.apple.dock launchanim -bool false

            # Background
            echo -e "\nChanging Background..."
            # Display available colors
                       echo "lease choose a background color:"
                       select color in Yellow "Turquoise Green" Teal Stone "Space Gray" "Space Gray Pro" "Soft Pink" Silver "Rose Gold" "Red Orange" Plum Ocher Gold "Gold 2" "Electric Blue" "Dusty Rose" Cyan "Blue Violet" Black
                       do
                           case $color in
                               *)
                                   # Construct the file path based on the selected color
                                   file_path="/System/Library/Desktop Pictures/Solid Colors/${color}.png"
                                   echo -e "\nYou will be prompted to allow Terminal Access to System Events. Please allow this and hit ${GREEN}ENTER${NC} to continue."

                                   # Apply the chosen color as the desktop background
                                   osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${file_path}\" as POSIX file"

                                   echo "Desktop background set to ${color}."
                                   break
                                   ;;
                           esac
                       done
                       sleep 2

            # Finder
            echo -e "\nChanging Finder Look..."
            # Change preferred view to Column View
            defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
            defaults write com.apple.finder ComputerViewSettings -dict CustomViewStyle clmv
            # Show hidden files
            defaults write com.apple.finder AppleShowAllFiles true
            # Show all file extensions
            defaults write NSGlobalDomain AppleShowAllExtensions -bool true
            # Do not show external hard drives on the desktop
            defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
            # Do not show internal hard drives on the desktop
            defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
            # Do not show removable media on the desktop
            defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
            # Remove Recent Folder
            defaults delete com.apple.finder FXRecentFolders
            # Show the path bar
            defaults write com.apple.finder ShowPathbar -bool true
            # Do not show recent tags
            defaults write com.apple.finder ShowRecentTags -bool false
            # Show the sidebar
            defaults write com.apple.finder ShowSidebar -bool true
            # Show the status bar
            defaults write com.apple.finder ShowStatusBar -bool true
            # Remove old Trash items
            defaults write com.apple.finder FXRemoveOldTrashItems -bool true
            # Open Documents Folder as default
            defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
            defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/"
            # Open folder in new window instead of tab
            defaults write com.apple.finder FinderSpawnTab -bool false
            # No warning on file extension change
            defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
            # No warning on iCloud removal change
            defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
            # Disable iCloud Drive for Desktop
            defaults write com.apple.finder FXICloudDriveDesktop -bool false
            # Disable iCloud Drive for Documents
            defaults write com.apple.finder FXICloudDriveDocuments -bool false
            # Disable iCloud Drive entirely
            defaults write com.apple.finder FXICloudDriveEnabled -bool false
            # Set iCloud Drive First Sync Down Complete to false
            defaults write com.apple.finder FXICloudDriveFirstSyncDownComplete -bool false
            # Set iCloud Drive login status to false
            defaults write com.apple.finder FXICloudLoggedIn -bool false
            # Restart Finder
            killall Finder
            # Restart Dock
            killall Dock

            valid_choice=true

        elif [[ "$choice" =~ ^[Nn]$ ]]; then
            echo -e "Continuing without changing the look.\n"
            valid_choice=true
        else
            echo "Invalid choice. Please enter 'y' or 'n'."
        fi
    done
}

# Run the function
cleanLook
