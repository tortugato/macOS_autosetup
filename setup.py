# setup.py

from utils import (
    installation_method,
    run_mandatory_installations,
    run_optional_installations,
    run_online_installation,
    finish_installation,
    clear_terminal
)
from user_interaction import get_user_confirmation


def main():
    clear_terminal()

    # Ask the user for online or offline install
    chosen_installation = not get_user_confirmation("Do you want to perform an online install?")

    clear_terminal()

    # Perform internet connection check based on user's choice
    installation_method(chosen_installation)

    # Run mandatory installations
    run_mandatory_installations()

    # Run optional installations
    run_optional_installations()

    # Handle online installation tasks
    run_online_installation(chosen_installation)

    # Finish installation process
    finish_installation()


if __name__ == "__main__":
    main()
