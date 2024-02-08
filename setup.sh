# Run Scripts separately
# Run commands that need sudo
sudo ./sudo_functions.sh

#check success
if [ $? -ne 0 ]; then
            exit
fi

# Install homebrew (can't be run with sudo)
./homebrew.sh