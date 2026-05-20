#!/usr/bin/env bash
# Module: filezilla
# Called by install-packages.sh orchestrator

install_filezilla() {
    printf "${YELLOW}Installing filezilla...\n${NC}"
    sudo apt-get -y install filezilla
}
