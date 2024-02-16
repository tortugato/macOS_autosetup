#!/bin/bash
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Reboot on finish
function rebootOnFinish() {
    echo -e "${BOLD}The Setup Scipt is finished.${NC}"
    echo -e "\n\nHit ${GREEN}ENTER${NC} to reboot now or ${RED}ctrl-c${NC} to reboot manually later."
    read
    reboot
}
rebootOnFinish
