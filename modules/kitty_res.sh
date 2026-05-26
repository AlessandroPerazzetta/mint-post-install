#!/usr/bin/env bash
# Module: kitty_res
# DESC: kitty resources
# DEFAULT: off
# REQUIRE: kitty
# ORDER: 70
# Called by install-packages.sh orchestrator

install_kitty_res() {
    printf "${YELLOW}Installing kitty resources...\n${NC}"
    printf "${YELLOW}Installing kitty resources from git sparse checkout...\n${NC}"
    mkdir -p /tmp/dotfiles-kitty.git
    cd /tmp/dotfiles-kitty.git
    git init
    git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
    git sparse-checkout set kitty
    git pull origin main
    mv kitty ~/.config/
    cd -
    rm -rf /tmp/dotfiles-kitty.git
}
