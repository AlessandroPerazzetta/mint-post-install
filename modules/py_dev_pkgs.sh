#!/usr/bin/env bash
# Module: py_dev_pkgs
# DESC: python dev packages
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_py_dev_pkgs() {
    printf "${YELLOW}Installing python dev packages...\n${NC}"
    sudo apt-get -y install python3-serial python3-pip python3-venv virtualenv
    sudo ln -s /usr/bin/python3 /usr/bin/python
}
