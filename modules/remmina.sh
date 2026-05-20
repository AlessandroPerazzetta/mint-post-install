#!/usr/bin/env bash
# Module: remmina
# DESC: Remmina
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_remmina() {
    printf "${YELLOW}Installing remmina...\n${NC}"
    if [[ ${RELEASE_NUMBER} -le 24 ]]; then
        sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
        sudo apt-get update
    fi
    sudo apt-get -y install remmina remmina-plugin-rdp remmina-plugin-secret
}
