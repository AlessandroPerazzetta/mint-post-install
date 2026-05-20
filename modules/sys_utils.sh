#!/usr/bin/env bash
# Module: sys_utils
# Called by install-packages.sh orchestrator

install_sys_utils() {
    printf "${YELLOW}Installing system utils...\n${NC}"
    sudo apt-get -y install bwm-ng screen htop bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/cat
}
