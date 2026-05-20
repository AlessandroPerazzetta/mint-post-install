#!/usr/bin/env bash
# Module: cliamp
# Called by install-packages.sh orchestrator

install_cliamp() {
    printf "${YELLOW}Installing cliamp...\n${NC}"
    curl -fsSL https://raw.githubusercontent.com/bjarneo/cliamp/HEAD/install.sh | sh
}
