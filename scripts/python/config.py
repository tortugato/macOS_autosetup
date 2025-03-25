# config.py
import os

# Get the absolute path of the current script's directory
PYTHON_DIR = os.path.dirname(os.path.abspath(__file__))
SHELL_DIR = os.path.abspath(os.path.join(PYTHON_DIR, "..", "shell"))
MAIN_DIR = os.path.abspath(os.path.join(PYTHON_DIR, "..", ".."))

# Constants for script paths
ONLINE_INSTALL_SHELL = f'"{os.path.join(SHELL_DIR, "online")}"'
OFFLINE_INSTALL_SHELL = f'"{os.path.join(SHELL_DIR, "offline")}"'

# Environment variable mappings
ENV_VARS = {
    "Install VPN": 'VPN_INSTALLED',
    "Install Firewall": 'FIREWALL_INSTALLED',
}

# Scripts for functions
# Mandatory
INTRODUCTION = f'"{os.path.join(SHELL_DIR, "introduction.sh")}"'
CHECK_FILEVAULT = f'sudo "{os.path.join(SHELL_DIR, "check_filevault.sh")}"'
INSTALL_SCRIPTS = f'sudo "{os.path.join(SHELL_DIR, "install_scripts.sh")}"'
SUDO_SET_SETTINGS = f'sudo "{os.path.join(SHELL_DIR, "set_settings_sudo.sh")}"'
NOSUDO_SET_SETTINGS = f'"{os.path.join(SHELL_DIR, "set_settings_no_sudo.sh")}"'
REBOOT = f'"{os.path.join(SHELL_DIR, "reboot_on_finish.sh")}"'
HOMEBREW = f'"{os.path.join(SHELL_DIR, "homebrew.sh")}"'
HOMEBREW_LS = f'"{os.path.join(SHELL_DIR, "homebrew_ls.sh")}"'
CONNECT_INTERNET = f'"{os.path.join(SHELL_DIR, "offline/connect_to_internet.sh")}"'
CONNECT_VPN = f'"{os.path.join(SHELL_DIR, "connect_to_vpn.sh")}"'

# Optional
CLEAN_LOOK = f'"{os.path.join(SHELL_DIR, "clean_look.sh")}"'
DISABLE_FUNCTIONS_SCRIPT = f'sudo "{os.path.join(SHELL_DIR, "disable_functions.sh")}"'
INSTALL_FIREWALL_OFFLINE = f'sudo "{os.path.join(SHELL_DIR, "offline/install_firewall.sh")}"'
INSTALL_FIREWALL_ONLINE = f'sudo "{os.path.join(SHELL_DIR, "online/install_firewall.sh")}"'
INSTALL_VPN_OFFLINE = f'sudo "{os.path.join(SHELL_DIR, "offline/install_vpn.sh")}"'
INSTALL_VPN_ONLINE = f'sudo "{os.path.join(SHELL_DIR, "online/install_vpn.sh")}"'
DOTFILES_SCRIPT = f'"{os.path.join(SHELL_DIR, "install_dotfiles.sh")}"'

# FINAL
REMOVE_SUDO = f'sudo "{os.path.join(SHELL_DIR, "remove_sudo.sh")}"'

# Installation scripts
MANDATORY_INSTALLATIONS = [
    {"title": "Introduction", "script": INTRODUCTION},
    {"title": "Turning FileVault On", "script": CHECK_FILEVAULT},
    {"title": "Installing Scripts", "script": INSTALL_SCRIPTS},
    {"title": "Setting important settings", "script": SUDO_SET_SETTINGS},
    {"title": "Setting important settings (no sudo)", "script": NOSUDO_SET_SETTINGS},
]

# Optional installation prompts and scripts
OPTIONAL_INSTALLATIONS = [
    {"prompt": "Do you want to Disable Features? (recommended)", "script": DISABLE_FUNCTIONS_SCRIPT,
     "title": "Disable Features"},
    {"prompt": "Do you want to Install a Firewall? (highly recommended)", "script": INSTALL_FIREWALL_OFFLINE,
     "title": "Install Firewall"},
    {"prompt": "Do you want to Install a VPN? (recommended)", "script": INSTALL_VPN_OFFLINE, "title": "Install VPN"},
    {"prompt": "Do you want to install dotfiles?", "script": DOTFILES_SCRIPT, "title": "Install Dotfiles"},
    {"prompt": "Do you want to clean up the look?", "script": CLEAN_LOOK, "title": "Cleaning up Look"},
]


# Add directories that are use imn the different script (e.g. firewall, vpn, dotfiles, ...)
