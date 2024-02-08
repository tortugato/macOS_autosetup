# -----------------------------------------------------------------------------------------
# Brew
# Install homebrew
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Switch to Apple Update Profile
echo "\n${RED}Make sure to active the 'Apple Update' Profile for the next step.${NC}"
echo "\nHit ${GREEN}ENTER${NC} when your internet is connected."
read 

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/test/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Switch to Apple Disabled Profile
echo "\n${RED}Make sure to active the 'Apple Disabled' Profile for the next steps.${NC}"
echo "\nHit ${GREEN}ENTER${NC} when your Profile is switched."
read 

# Update brew and then install important programs
clear
brew update

brew bundle --file brewfiles/Brewfile_security