#!/usr/bin/env bash
# Module: brave_ext
# Called by install-packages.sh orchestrator

install_brave_ext() {
    printf "${YELLOW}Installing brave-browser extensions...\n${NC}"
    install_brave_extensions "/opt/brave.com/brave"
}
