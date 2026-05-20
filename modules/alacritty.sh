#!/usr/bin/env bash
# Module: alacritty
# Called by install-packages.sh orchestrator

install_alacritty() {
    printf "${YELLOW}Installing alacritty...\n${NC}"
    # Check if rust is installed, required to build alacritty
    if ! command_exists rustc; then
        printf "${YELLOW}Rust not found, installing rust...\n${NC}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source $HOME/.cargo/env
    fi
    sudo apt-get -y install pkg-config libfreetype6-dev libfontconfig1-dev
    cd /tmp/
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin/
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo dekstop-file-install extra/linux/Alacritty.desktop
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    printf "${YELLOW}Set alacritty as default terminal on cinnamon...\n${NC}"
    dconf write /org/cinnamon/desktop/applications/terminal/exec "'/usr/local/bin/alacritty'"
    sudo update-alternatives --set x-terminal-emulator /usr/local/bin/alacritty
}
