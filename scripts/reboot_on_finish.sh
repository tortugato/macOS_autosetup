#!/bin/bash
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Reboot on finish
function rebootOnFinish() {
    echo -e "${BOLD}The Setup Script is finished.${NC}"
    echo -e "\n\nHit ${GREEN}ENTER${NC} to reboot now or ${RED}ctrl-c${NC} to reboot manually later."
    read
    echo -e "\n${RED}Since your account is not an admin anymore you will be promted twice for the password you just assigned.${NC}"
    sufo reboot
}

rebootOnFinish
