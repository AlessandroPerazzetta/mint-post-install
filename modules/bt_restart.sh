#!/usr/bin/env bash
# Module: bt_restart
# DESC: bt-restart
# DEFAULT: off
# ORDER: 660
# Called by install-packages.sh orchestrator

install_bt_restart() {
    printf "${YELLOW}Installing bt-restart...\n${NC}"
    sudo curl -fsSLo /lib/systemd/system-sleep/bt https://raw.githubusercontent.com/AlessandroPerazzetta/bt-restart/main/bt
    sudo chmod +x /lib/systemd/system-sleep/bt
}
