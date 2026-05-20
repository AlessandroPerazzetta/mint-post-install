#!/usr/bin/env bash
# Module: qownnotes
# DESC: QOwnNotes
# DEFAULT: on
# ORDER: 290
# Called by install-packages.sh orchestrator

install_qownnotes() {
    printf "${YELLOW}Installing qownnotes...\n${NC}"
    sudo apt-add-repository -y ppa:pbek/qownnotes
    sudo apt-get update
    sudo apt-get -y install qownnotes
}
