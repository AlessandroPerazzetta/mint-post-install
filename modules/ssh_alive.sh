#!/usr/bin/env bash
# Module: ssh_alive
# DESC: ssh alive settings
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_ssh_alive() {
    printf "${YELLOW}Installing ssh alive settings...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
    sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE
    sudo sed -i -e "s/ServerAliveInterval 240/ServerAliveInterval 15/g" /etc/ssh/ssh_config
    sudo bash -c 'echo "    ServerAliveCountMax=1" >> /etc/ssh/ssh_config'
}
