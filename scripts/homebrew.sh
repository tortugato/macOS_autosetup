# Brew
# Install homebrew
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Switch to Apple Update Profile
echo -e "\n${RED}Make sure to active the 'Apple Update' Profile for the next step.${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} when you activated 'Apple Update'."
read

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)
rm /Users/$USER/.zshrc
touch /Users/$USER/.zshrc
echo 'export PATH=/opt/homebrew/bin:$PATH' >> /Users/$USER/.zshrc
source /Users/$USER/.zshrc

# Switch to Apple Disabled Profile
echo -e "\n${RED}Make sure to active the 'Apple Disabled' Profile for the next steps.${NC}"
echo -e "\nHit ${GREEN}ENTER${NC} when your Profile is switched."
read

# Update brew
brew update

# Install important programs
brew bundle --file brewfiles/Brewfile_security


# Ask to install custom brew file

function checkBrewfile() {
    main_dir=$(dirname "$(dirname "$(realpath "$0")")")
    brew_file="$main_dir/brewfiles/Brewfile_custom"

    while true; do
        if [ ! -e "$brew_file" ]; then
            clear
            echo -e "${RED}The required Brew file ('Brewfile_other') is missing at $brew_file.${NC}"
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


while [ "$valid_choice" == false ]; do
    echo -n "Do you want to install a custom brewfile? (y/n): "
    read -r choice

    if [[ "$choice" == "y" || "$choice" == "Y" || -z "$choice" ]]; then
        # Run the specified command
        checkBrewfile
        brew bundle --file brewfiles/Brewfile_custom

        clear
        valid_choice=true
    elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
        echo -e "Continuing without running the function.\n"
        valid_choice=true
    else
        echo "Invalid choice. Please enter 'y' or 'n'."
    fi
done
