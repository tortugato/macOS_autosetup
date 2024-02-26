# Brew
# Install homebrew
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Getting the main dir
main_dir=$(dirname "$(dirname "$(realpath "$0")")")

# Switch to Apple Update Profile
echo -e "\n${RED}Make sure to active the 'Apple Update' Profile for the next step.${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} when you activated 'Apple Update'."
read

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)
sudo chown $USER /Users/$USER/.zshrc
echo 'export PATH=/opt/homebrew/bin:$PATH' >> /Users/$USER/.zshrc
source /Users/$USER/.zshrc

# Switch to Apple Disabled Profile
echo -e "\n${RED}Make sure to active the 'Apple Disabled' Profile for the next steps.${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} when your Profile is switched."
read
# Turn Analytics off
echo -e "\n${BOLD}Turning Brew Analytics off${NC}"
brew analytics off

# Update brew
echo -e "\n${BOLD}Updating Brew${NC}"
brew update

# Install important programs
echo -e "\n${BOLD}Installing the Security Brewfile${NC}"
brew bundle --file "$main_dir/config/brewfiles/Brewfile_security"


# Ask to install custom brew file
# Function to check for the existence of the custom Brewfile
function checkBrewfile() {
    brew_file="$main_dir/config/brewfiles/Brewfile_custom"
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
}

# Ask the user if they want to install a custom Brewfile
echo -n "Do you want to install a custom Brewfile? (y/n): "
read -r choice

if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
    # Run the specified command
    checkBrewfile
    brew bundle --file "$main_dir/config/brewfiles/Brewfile_custom"

    clear
    echo "Installation completed."
else
    echo "Continuing without installing a custom Brewfile."
fi
