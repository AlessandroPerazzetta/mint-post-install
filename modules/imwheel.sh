#!/usr/bin/env bash
# Module: imwheel
# DESC: imwheel
# DEFAULT: off
# ORDER: 630
# Called by install-packages.sh orchestrator

install_imwheel() {
    printf "${YELLOW}Installing imwheel...\n${NC}"
    sudo apt-get -y install imwheel
    curl -fsSLo ~/mousewheel.sh https://raw.githubusercontent.com/AlessandroPerazzetta/imwheel/main/mousewheel.sh
    chmod +x ~/mousewheel.sh
    ~/mousewheel.sh
}
