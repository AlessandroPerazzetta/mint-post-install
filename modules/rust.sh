#!/usr/bin/env bash
# Module: rust
# DESC: Rust
# DEFAULT: on
# Called by install-packages.sh orchestrator

install_rust() {
    printf "${YELLOW}Installing rust...\n${NC}"
    if ! command -v rustc &> /dev/null
    then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        printf "${RED}Installing rust, rustc found. Rust already present...\n${NC}"
    fi
}
