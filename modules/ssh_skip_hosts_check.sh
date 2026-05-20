#!/usr/bin/env bash
# Module: ssh_skip_hosts_check
# DESC: ssh skip hosts check
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_ssh_skip_hosts_check() {
    printf "${YELLOW}Installing ssh skip hosts check settings...\n${NC}"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
    sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS
    sudo bash -c 'echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
    sudo bash -c 'echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config'
}
