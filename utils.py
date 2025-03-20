# utils.py

from helpers import *
from config import *


def installation_method(chosen_installation):
    """Perform internet connection check based on online or offline choice."""
    path_suffix = OFFLINE_INSTALL_SCRIPT if chosen_installation else ONLINE_INSTALL_SCRIPT

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


def run_optional_installations():
    """Run optional installation scripts based on user confirmation."""
    for installation in OPTIONAL_INSTALLATIONS:
        prompt = installation["prompt"]
        script = installation["script"]
        title = installation["title"]

        print_section_heading(title)
        run_functions(prompt, script, title)


def run_online_installation(chosen_installation):
    """Handle tasks related to online installation."""
    if chosen_installation:
        print_section_heading("Connect to Internet")
        run_command(f"{OFFLINE_INSTALL_SCRIPT}/connect_to_internet.sh")

    # Check if the user chose to install the VPN
    if os.getenv('VPN_INSTALLED') == 'true':
        print_section_heading("Connect to VPN")
        run_command("./scripts/connect_to_vpn.sh")

    # Install homebrew and some necessary packages
    print_section_heading("Homebrew")

    if os.getenv('FIREWALL_INSTALLED') == 'true' and os.path.exists("/Applications/Little Snitch.app"):
        run_command("./scripts/homebrew_ls.sh")
    else:
        run_command("./scripts/homebrew.sh")


def finish_installation():
    """Perform final cleanup and reboot."""
    # Removing Admin Privileges
    print_section_heading("Removing Admin Privileges")
    run_command(REMOVE_SUDO)

    # Reboot on finish
    print_section_heading("Script Finished!")
    run_command(REBOOT)
