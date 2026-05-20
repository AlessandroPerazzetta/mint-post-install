#!/usr/bin/env bash
# Module: personal_res
# DESC: Personal resources
# DEFAULT: on
# ORDER: 720
# Called by install-packages.sh orchestrator

install_personal_res() {
    printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
    printf "${YELLOW}Installing aliases resources...\n${NC}"
    printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bash_aliases
}
