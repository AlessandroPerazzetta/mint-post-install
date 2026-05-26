#!/usr/bin/env bash
# Module: dbeaver
# DESC: DBeaver
# DEFAULT: on
# ORDER: 340
# Called by install-packages.sh orchestrator

install_dbeaver() {
    printf "${YELLOW}Installing dbeaver...\n${NC}"
    sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb
}
