#!/usr/bin/env bash
# shellcheck source=colors.sh
source "${LIB_DIR}/colors.sh"

# Function to check if a command exists
# The command_exists function checks if a given command is available in the system's PATH. It uses the command -v command,
# which returns the path to the executable if it exists, or nothing if it doesn't.
# The function returns 0 (success) if the command exists, and 1 (failure) if it does not.
command_exists() {
    command -v $1 >/dev/null 2>&1
}

# Function to check if a command exists using APT
# This will return 0 if the package is installed, 1 otherwise.
command_exists_apt() {
    dpkg -s "$1" 2>/dev/null | grep -q "Status: install ok installed"
}

# Function to install Brave browser extensions into a given Brave installation path.
# Usage: install_brave_extensions <brave_install_path>
install_brave_extensions() {
    local BRAVE_PATH="$1"
    local BRAVE_EXTENSIONS_PATH="$BRAVE_PATH/extensions"
    if [ -d "$BRAVE_PATH" ]; then
        sudo mkdir -p "${BRAVE_EXTENSIONS_PATH}"
        declare -A EXTlist=(
            ["ublock-origin"]="cjpalhdlnbpafiamejdnhcphjbkeiagm"
            ["bypass-adblock-detection"]="lppagnomjcaohgkfljlebenbmbdmbkdj"
            ["hls-downloader"]="hkbifmjmkohpemgdkknlbgmnpocooogp"
            ["i-dont-care-about-cookies"]="fihnjjcciajhdojfnbdddfaoknhalnja"
            ["keepassxc-browser"]="oboonakemofpalcgghocfoadofidjkkk"
            ["session-buddy"]="edacconmaakjimmfgnblocblbcdcpbko"
            ["the-marvellous-suspender"]="noogafoofpebimajpfpamcfhoaifemoa"
            ["url-tracking-stripper-red"]="flnagcobkfofedknnnmofijmmkbgfamf"
            ["video-downloader-plus"]="njgehaondchbmjmajphnhlojfnbfokng"
            ["youtube-nonstop"]="nlkaejimjacpillmajjnopmpbkbnocid"
            ["user-agent-switcher-for-c"]="djflhoibgkdhkhhcedjiklpkjnoahfmg"
            ["modheader-modify-http-hea"]="idgpnmonknjnojddfkpgkljpfnnfcklj"
            ["enhancer-for-youtube"]="ponfpcnoihfmfllpaingbgckeeldkhle"
            ["disable-twitch-extensions"]="nmogopjdbhhnbkiklkdahphkdpbjfine"
        )
        for i in "${!EXTlist[@]}"; do
            sudo bash -c "echo -e '{ \"external_update_url\": \"https://clients2.google.com/service/update2/crx\" }' > ${BRAVE_EXTENSIONS_PATH}/${EXTlist[$i]}.json"
        done
    else
        printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
        printf "ERROR Brave path not found, extensions not installed !!!\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        read -n 1 -s -r -p "Press any key to continue"
        sleep 3
        printf "\n${NC}"
    fi
}
