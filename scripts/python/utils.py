# utils.py

from scripts.python.config import *
from scripts.python.helpers import *


def installation_method(chosen_installation):
    """Perform internet connection check based on online or offline choice."""
    path_suffix = OFFLINE_INSTALL_SHELL if chosen_installation else ONLINE_INSTALL_SHELL

    # Corrected path to check internet connection status
    check_internet_script = os.path.join(path_suffix, "check_internet.sh")
    print_section_heading("Turning Internet Connection " + ("off" if chosen_installation else "on"))
    run_command(f"sudo {check_internet_script}")


def run_mandatory_installations():
    """Run mandatory installations."""
    for installation in MANDATORY_INSTALLATIONS:
        title = installation["title"]
        script = installation["script"]

        print_section_heading(title)
        run_command(script)


def run_optional_installations(chosen_installation):
    """Run optional installation scripts based on user confirmation."""

    for installation in OPTIONAL_INSTALLATIONS:
        prompt = installation["prompt"]
        title = installation["title"]

        # Check if the title is "Install Firewall"
        if title == "Install Firewall":
            # Set script based on chosen_installation
            if not chosen_installation:
                script = INSTALL_FIREWALL_ONLINE
        elif title == "Install VPN":
            if not chosen_installation:
                script = INSTALL_VPN_ONLINE
        else:
            # Default script from installation dictionary
            script = installation["script"]

        print_section_heading(title)
        run_functions(prompt, script, title)


def run_online_installation(chosen_installation):
    """Handle tasks related to online installation."""
    if chosen_installation:
        print_section_heading("Connect to Internet")
        run_command(CONNECT_INTERNET)

    # Check if the user chose to install the VPN
    if os.getenv('VPN_INSTALLED') == 'true':
        print_section_heading("Connect to VPN")
        run_command(CONNECT_VPN)

    # Install homebrew and some necessary packages
    print_section_heading("Homebrew")

    if os.getenv('FIREWALL_INSTALLED') == 'true' and os.path.exists("/Applications/Little Snitch.app"):
        run_command(HOMEBREW_LS)
    else:
        run_command(HOMEBREW)


def finish_installation():
    """Perform final cleanup and reboot."""
    # Removing Admin Privileges
    print_section_heading("Removing Admin Privileges")
    run_command(REMOVE_SUDO)

    # Reboot on finish
    print_section_heading("Script Finished!")
    run_command(REBOOT)
