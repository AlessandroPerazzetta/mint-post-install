#!/usr/bin/env bash
# Module: latest_pip
# DESC: latest python pip
# DEFAULT: on
# ORDER: 450
# Called by install-packages.sh orchestrator

install_latest_pip() {
    printf "${YELLOW}Installing latest pip...\n${NC}"
    curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
    sudo -H python /tmp/get-pip.py --break-system-packages
    sudo ln -s /usr/local/bin/pip3 /usr/bin/pip3
}
