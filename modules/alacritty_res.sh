#!/usr/bin/env bash
# Module: alacritty_res
# Called by install-packages.sh orchestrator

install_alacritty_res() {
    printf "${YELLOW}Installing alacritty resources...\n${NC}"
    printf "${YELLOW}Installing alacritty resources from git sparse checkout...\n${NC}"
    mkdir -p /tmp/dotfiles-alacritty.git
    cd /tmp/dotfiles-alacritty.git
    git init
    git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
    git sparse-checkout set alacritty
    git pull origin main
    mv alacritty ~/.config/
    cd -
    rm -rf /tmp/dotfiles-alacritty.git
}
