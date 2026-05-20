#!/usr/bin/env bash
# Module: py_38
# DESC: python 3.8.19 (src install)
# DEFAULT: off
# ORDER: 430
# Called by install-packages.sh orchestrator

install_py_38() {
    printf "${YELLOW}Installing python 3.8.19 (src install)...\n${NC}"
    sudo apt-get -y install build-essential checkinstall virtualenv
    sudo apt-get -y install libncurses-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
    cd /tmp
    sudo curl -O https://www.python.org/ftp/python/3.8.19/Python-3.8.19.tgz
    sudo tar xzf Python-3.8.19.tgz
    cd Python-3.8.19
    sudo ./configure --enable-optimizations
    sudo make altinstall
    printf "${YELLOW}Installing multiple python...\n${NC}"
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
    sudo update-alternatives --install /usr/bin/python3.8 python3.8 /usr/local/bin/python3.8 38
}
