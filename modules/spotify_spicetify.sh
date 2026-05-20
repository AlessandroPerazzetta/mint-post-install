#!/usr/bin/env bash
# Module: spotify_spicetify
# DESC: spotify + spicetify
# DEFAULT: off
# ORDER: 680
# Called by install-packages.sh orchestrator

install_spotify_spicetify() {
    printf "${YELLOW}Installing spotify and spicetify...\n${NC}"
    cd ~
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get -y install spotify-client
    # https://community.spotify.com/t5/Desktop-Linux/The-app-crashes-on-Debian-due-to-HW-acceleration/td-p/5049188
    # https://codereview.chromium.org/2384163002
    # spotify --no-zygote
    spotify && killall spotify
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Please restart shell and launch command to apply spicetify: \n\n"
    printf "spicetify backup apply\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
}
