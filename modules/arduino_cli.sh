#!/usr/bin/env bash
# Module: arduino_cli
# DESC: arduino-cli
# DEFAULT: on
# ORDER: 380
# Called by install-packages.sh orchestrator

install_arduino_cli() {
    printf "${YELLOW}Installing arduino-cli...\n${NC}"
    sudo mkdir -p /opt/arduino-cli/
    sudo chown "$CURRENT_USER":"$CURRENT_USER" /opt/arduino-cli
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/opt/arduino-cli sh
    sudo ln -s /usr/bin/python3 /usr/bin/python
}
