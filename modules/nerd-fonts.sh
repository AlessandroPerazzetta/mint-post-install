#!/usr/bin/env bash
# Module: nerd-fonts
# DESC: nerd-fonts
# DEFAULT: on
# ORDER: 600
# Called by install-packages.sh orchestrator

install_nerd_fonts() {
    printf "${YELLOW}Installing nerd-fonts (FiraCode)...\n${NC}"
    declare -a fonts=(
        # BitstreamVeraSansMono
        # CodeNewRoman
        # DroidSansMono
        FiraCode
        # FiraMono
        # Go-Mono
        # Hack
        # Hermit
        JetBrainsMono
        # Meslo
        # Noto
        # Overpass
        # ProggyClean
        # RobotoMono
        # SourceCodePro
        # SpaceMono
        # Ubuntu
        # UbuntuMono
    )
    mkdir -p ~/.local/share/fonts/
    cd /tmp

    # curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |grep "browser_download_url.*FiraCode.zip" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 curl -L -o FiraCodeNerdFont.zip
    # unzip FiraCodeNerdFont.zip -d ~/.local/share/fonts/
    for font in "${fonts[@]}"; do
        printf "${LCYAN}- Font: ${font}\n${NC}"
        curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |grep "browser_download_url.*${font}.zip" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 curl -L -o /tmp/${font}NerdFont.zip
        unzip /tmp/${font}NerdFont.zip -d ~/.local/share/fonts/
        printf "\n${NC}"
    done
    fc-cache -fv
}
