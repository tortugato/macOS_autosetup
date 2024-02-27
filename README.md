# macOS_autosetup - Privacy and Security
![Status](https://img.shields.io/badge/status-Work_in_Progress-yellow)
![GitHub Tag](https://img.shields.io/github/v/tag/tortugato/macOS_autosetup)


Privacy and Security focused setup script for macOS


I created this script to automate the setup of my macOS system. I want my system to be
- private and
- secure

(<em>Then why don't you use Linux? Because I enjoy the performance and ease of use of the latest MacBooks</em>)

### Overview
This script will:
- activate FileVault
- install some useful scripts
- set some important settings
- (optional) disable privacy invading features
- (optional) install a firewall
- (optional) install a vpn
- install homebrew
- install some basic packages
- (optional) install custom packages
- clean up the look of the system


If you have any suggestions feel free to open an [issue](https://github.com/tortugato/macOS_autosetup/issues/new/choose).

## Before Installation
I recommend to do the initial setup of your macOS system as following:

1. Choose Language
2. Choose Country
3. Accessibility - Click "Not Now"
4. WiFi Network - Choose "Other Network Options", then "My computer does not connect to the internet". Click "Continue" and "Continue" again if requested to connect to the internet.
5. Migration Assistant - Free Choice, I like to start off a clean slate ("Not Now" and manually transfer files after setup)
6. Apple ID - "Set Up Later", then "Skip"
7. Terms and Conditions - Agree
8. Fill in Name and choose a STRONG Password, don't enter a Hint
9. Location Services - Don't enable, then "Don't Use"
10. Select Timezone
11. Analytics - Uncheck everything
12. Screen Time - Set Up Later
13. Siri - Uncheck "Enable Ask Siri"
14. TouchID - Add TouchID for more discrete unlocking in public
14. Choose desired theme

## Installation
1. I recommend copying the repository and optional files to a USB Stick or an other external volume. This ensures an offline installation.
    Optional files may be:
    - vpn.pkg/vpn.dmg
    - firewall.dmg
    - Brewfile_custom
    **Make sure to move those to the corresponding directories before starting the script.**


2. Go to the `macOS_autosetup` directory
    ```bash
    cd /DirectoryOfExternalVolume/macOS_autosetup
    ```

3. Start the `setup.sh` script
    ```bash
    ./script.sh
    ```

4. Follow the instructions
5. Before and after if you choose the "Clean Look" option\
![Before](https://github.com/tortugato/macOS_autosetup/blob/main/img/original.jpg) ![After](https://github.com/tortugato/macOS_autosetup/blob/main/img/clean.jpg)

## After Installation
### Optional:
If you are using LittleSnitch, log in to your account


### How to use installed scripts

1. **App-Cleaner Script**\
This script deletes a program and all of its remaining files\
Usage:
    ```bash
    app-cleaner.sh /Applications/AppToUninstall.app
    ```
    or
    ```bash
    app-cleaner.sh ~/Applications/AppToUninstall.app
    ```

2. **Cleanup Script**\
This script removes temporary files, cache and other unneccessary files to free up space
    ```bash
    cleanup
    ```

3. **Update Script**\
This script updates the system using brew
    ```bash
    update
    ```

4. **Spoof.sh script**\
This script spoofs the MacAddress and sets a generic Hostname. It gets executed automatically on each reboot but can also be started manually.
    ```bash
    spoof.sh
    ```

### How to use installed Applications
- **KnockKnock**\
	Run KnockKnock regularly to check for persistently installed software
- **Onyx**\
	Use Onyx to set some custom settings. You can also use Onyx to clear temporary data etc.
- **VeraCrypt**\
	Consider creating an encrypted Volume or use VeraCrypt to encrypt external Volumes
### ToDo:
There are a few settings that still need to be changed manually. This includes:
- Recent documents, applications and servers (none) - This can be changed from Control Centre (macOS 14+) or Desktop & Dock (macOS < 14)
- Sidebar Settings in Finder
- Ask to join Hotspots (off) - This can be changed from Settings -> Wifi


## This project was inspired by:
#### [Sun Knudsen](https://github.com/sunknudsen)
The [app-cleaner](https://github.com/sunknudsen/privacy-guides/tree/master/how-to-clean-uninstall-macos-apps-using-appcleaner-open-source-alternative) and [spoof.sh](https://github.com/sunknudsen/privacy-guides/tree/master/how-to-spoof-mac-address-and-hostname-automatically-at-boot-on-macos) script are modified versions of his.\
**App-cleaner**: I added the removal of brew files and removed the saving of bill of material logs.\
**Spoof.sh**: Instead of adding a random name infront of the Hostname I stick to using a generic Hostname like MacBook or MacBook-Pro.

## FAQ

**Q: Is this script the ultimate privacy, security and hardening setup for macOS?**

**A:** No. But I will try to add as many privacy, security and hardening features to this script as possible without limiting the general usage of your mac device.


**Q: Why is XYZ not in the script?**

**A:** I will continue to add features to this setup script, please open an [issue](https://github.com/tortugato/macOS_autosetup/issues/new/choose), if your desired feature is currently not part of the script.


**Q: Why is disabling Gatekeeper recommended?**

**A:** The Gatekeeper feature on macOS sends data about your applications to Apple for verification each time you open an application and prevents unknown apps from opening. Due to privacy concerns, I wish to disable this feature to avoid Apple tracking my software usage.
If you or the person you are running the script for are not that tech-savvy, you can leave the gatekeeper enabled for security reasons.
