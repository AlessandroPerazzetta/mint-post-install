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

# Version Matrix
# Linux Mint Version,Mint Codename,Underlying Ubuntu Base,Ubuntu Codename
# "Mint 23, 23.1, 23.2","Vanessa, Vera, Victoria"   ->  Ubuntu 26.04 LTS,Resolut
# "Mint 22, 22.1, 22.2","Wilma, Xia, ..."   ->  Ubuntu 24.04 LTS,Noble Numbat
# "Mint 21, 21.1, 21.2, 21.3","Vanessa, Vera, Victoria, Virginia"   ->  Ubuntu 22.04 LTS,Jammy Jellyfish
# "Mint 20, 20.1, 20.2, 20.3","Ulyana, Ulyssa, Uma, Una"    ->  Ubuntu 20.04 LTS,Focal Fossa
# "Mint 19, 19.1, 19.2, 19.3","Tara, Tessa, Tina, Tricia"   ->  Ubuntu 18.04 LTS,Bionic Beaver
# "Mint 17 to 17.3,"Qiana, Rebecca, Rafaela, Rosa"  ->  Ubuntu 14.04 LTS,Trusty Tahr

# Detect Linux Mint version and set the following globals:
#   MINT_VERSION        full release string  (e.g. "22.1")
#   MINT_MAJOR_VERSION  major number         (e.g. "22")
#   MINT_MINOR_VERSION  minor number         (e.g. "1")
#   RELEASE_NUMBER      alias for MINT_MAJOR_VERSION (kept for compatibility)
#   UBUNTU_CODENAME     underlying Ubuntu codename (e.g. "noble")
detect_mint_version() {
    MINT_VERSION="$(lsb_release -rs | tr -d '\r\n')"
    MINT_MAJOR_VERSION="$(echo "$MINT_VERSION" | cut -d. -f1)"
    MINT_MINOR_VERSION="$(echo "$MINT_VERSION" | cut -d. -f2)"
    RELEASE_NUMBER="$MINT_MAJOR_VERSION"
    UBUNTU_CODENAME="$(. /etc/os-release 2>/dev/null && echo "${UBUNTU_CODENAME:-}")"
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
            ["simple-color-picker"]="oekcgbklihkajpddgklkakahiabhcjhm"
            ["fetchv-video-downloader-f"]="nfmmmhanepmpifddlkkmihkalkoekpfd"
            ["the-stream-detector"]="iakkmkmhhckcmoiibcfjnooibphlobak"
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
