# config.py

# Constants for script paths
SCRIPTS_DIR = "./scripts"
ONLINE_INSTALL_SCRIPT = f"{SCRIPTS_DIR}/online"
OFFLINE_INSTALL_SCRIPT = f"{SCRIPTS_DIR}/offline"

# Environment variable mappings
ENV_VARS = {
    "Install VPN": 'VPN_INSTALLED',
    "Install Firewall": 'FIREWALL_INSTALLED',
}

# Scripts for functions
# Mandatory
INTRODUCTION = "./scripts/introduction.sh"
CHECK_FILEVAULT = "sudo ./scripts/check_filevault.sh"
INSTALL_SCRIPTS = "sudo ./scripts/install_scripts.sh"
SUDO_SET_SETTINGS = "sudo ./scripts/set_settings_sudo.sh"
NOSUDO_SET_SETTINGS = "./scripts/set_settings_no_sudo.sh"
REBOOT = "./scripts/reboot_on_finish.sh"

# Optional
CLEAN_LOOK = "./scripts/clean_look.sh"
DISABLE_FUNCTIONS_SCRIPT = "sudo ./scripts/disable_functions.sh"
INSTALL_FIREWALL_SCRIPT = f"sudo {OFFLINE_INSTALL_SCRIPT}/install_firewall.sh"
INSTALL_VPN_SCRIPT = f"sudo {OFFLINE_INSTALL_SCRIPT}/install_vpn.sh"
DOTFILES_SCRIPT = "./scripts/install_dotfiles.sh"

# FINAL
REMOVE_SUDO = "sudo ./scripts/remove_sudo.sh"

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
    {"prompt": "Do you want to Disable Features? (recommended)", "script": DISABLE_FUNCTIONS_SCRIPT, "title": "Disable Features"},
    {"prompt": "Do you want to Install a Firewall? (highly recommended)", "script": INSTALL_FIREWALL_SCRIPT, "title": "Install Firewall"},
    {"prompt": "Do you want to Install a VPN? (recommended)", "script": INSTALL_VPN_SCRIPT, "title": "Install VPN"},
    {"prompt": "Do you want to install dotfiles?", "script": DOTFILES_SCRIPT, "title": "Install Dotfiles"},
    {"prompt": "Do you want to clean up the look?", "script": CLEAN_LOOK, "title": "Cleaning up Look"},
]


