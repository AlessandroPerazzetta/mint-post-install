#!/usr/bin/env bash
# Module: filezilla
# DESC: FileZilla
# DEFAULT: on
# ORDER: 470
# Called by install-packages.sh orchestrator

install_filezilla() {
    printf "${YELLOW}Installing filezilla...\n${NC}"
    sudo apt-get -y install filezilla
}
