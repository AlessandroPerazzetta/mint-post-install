#!/usr/bin/env bash
# Module: telegram
# DESC: Telegram
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_telegram() {
    printf "${YELLOW}Installing telegram...\n${NC}"
    curl -fsSLo /tmp/Telegram.xz https://telegram.org/dl/desktop/linux
    sudo tar -xf /tmp/Telegram.xz -C /opt/
}
