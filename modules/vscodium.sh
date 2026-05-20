#!/usr/bin/env bash
# Module: vscodium
# Called by install-packages.sh orchestrator

install_vscodium() {
    printf "${YELLOW}Installing vscodium...\n${NC}"
    # curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
    # echo 'deb [arch=amd64] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

    if [[ ${RELEASE_NUMBER} -le 23 ]]; then
        printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
        printf "Writing vscode repository for v23 or older...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"

        curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
        echo 'deb [arch=amd64] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
    elif [[ ${RELEASE_NUMBER} -ge 24 ]]; then
        printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
        printf "Writing vscode repository for v24 or newer ...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"

        curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
        echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/vscodium.sources
    else
        printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
        printf "Release number not recognized, vscode repository not installed...\n"
        printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
        sleep 5
    fi
    sudo apt-get update && sudo apt-get -y install codium

    printf "${YELLOW}Installing vscodium MS marketplace CONFIG in ~/.config/VSCodium/product.json ...\n${NC}"
    # --------------------------------------------------------------------------------------------------
    # OLD Script to replace marketplace in extensionsGallery on products.json
    # printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
    # cd /usr/local/sbin/
    # sudo git clone https://github.com/AlessandroPerazzetta/vscodium-json-updater
    # cd -
    # sudo /usr/local/sbin/vscodium-json-updater/update.sh
    # --------------------------------------------------------------------------------------------------
    # NEW Script to replace marketplace in extensionsGallery on products.json (local user config)
    mkdir -p ~/.config/VSCodium/
    bash -c "echo -e '{\n  \"nameShort\": \"Visual Studio Code\",\n  \"nameLong\": \"Visual Studio Code\",\n  \"extensionsGallery\": {\n    \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",\n    \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",\n    \"itemUrl\": \"https://marketplace.visualstudio.com/items\"\n  }\n}\n' > ~/.config/VSCodium/product.json"

    printf "${YELLOW}Installing vscodium MS marketplace ENV in /etc/profile.d/vscode-market.sh ...\n${NC}"
    sudo bash -c "echo -e 'export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'\nexport VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'\nexport VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'\nexport VSCODE_GALLERY_CONTROL_URL=''' > /etc/profile.d/vscode-market.sh"
}
