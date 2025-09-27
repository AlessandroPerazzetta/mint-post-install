#!/bin/bash
CURRENT_USER=$(whoami)
RELEASE_NUMBER="$(lsb_release -rs | cut -d. -f1|tr -d '\r\n')"

# Colors definition
BLACK='\033[0;30m'
DGRAY='\033[1;30m'
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
LPURPLE='\033[1;35m'     
CYAN='\033[0;36m'
LCYAN='\033[1;36m'
LGRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

export NEWT_COLORS='
    root=green,black
    border=green,black
    title=green,black
    roottext=white,black
    window=green,black
    textbox=white,black
    button=black,green
    compactbutton=white,black
    listbox=white,black
    actlistbox=black,white
    actsellistbox=black,green
    checkbox=green,black
    actcheckbox=black,green
'

printf "${YELLOW}------------------------------------------------------------------\n${NC}"
printf "${YELLOW}Starting ...\n${NC}"
printf "${YELLOW}------------------------------------------------------------------\n${NC}"

printf "${YELLOW}Updating system...\n${NC}"
sleep 1
sudo apt-get update
sudo apt-get -y upgrade

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1

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

# sudo apt-get -y install build-essential apt-transport-https curl sshfs dialog git
commands_to_check_exist=("build-essential" "apt-transport-https" "curl" "sshfs" "git" "jq")
for cmd in "${commands_to_check_exist[@]}"; do
    # if ! command_exists $cmd; then
    if command_exists $cmd && command_exists_apt $cmd; then
        printf "${LGREEN}Command ${cmd} is already installed.\n${NC}"
    else
        printf "${LCYAN}Command ${cmd} not found. Installing... \n${NC}"
        sudo apt-get -y install $cmd
        printf "\n${NC}"
    fi
done
sleep 1

read dialog <<< "$(which whiptail dialog 2> /dev/null)"
[[ "$dialog" ]] || {
    printf "${LRED}Neither whiptail nor dialog found\n${NC}"
    exit 1
}

# Define all options and their default status in an array of "key|desc|default"
ALL_OPTIONS=(
    "personal_res|Personal resources|on"
    "sys_serial|System Serial permission|on"
    "xed_res|Xed theme resources|on"
    "gedit_res|Gedit theme resources|on"
    "sys_tweaks|System tewaks|on"
    "sys_utils|System utils|on"
    "cinnamon_spices|cinnamon_spices|on"
    "nemo_actions|nemo_actions|on"
    "neovim|neovim|on"
    "filezilla|filezilla|on"
    "meld|meld|on"
    "vlc|vlc|on"
    "kitty|kitty|on"
    "kitty_res|kitty resources|on"
    "tmux|tmux|on"
    "tmux_res|tmux resources|on"
    "brave|brave-browser|on"
    "brave_ext|brave-browser extensions|on"
    "remmina|remmina|on"
    "vscodium|vscodium|on"
    "vscode_nemo_actions|vscode_nemo_actions|on"
    "vscodium_ext|vscodium extensions|on"
    "marktext|marktext|on"
    "dbeaver|dbeaver|on"
    "smartgit|smartgit|off"
    "mqtt_explorer|mqtt-explorer|on"
    "arduino_cli|arduino-cli|on"
    "keepassxc|keepassxc|on"
    "qownnotes|qownnotes|on"
    "virtualbox|virtualbox|on"
    "kicad|kicad|off"
    "freecad|freecad|off"
    "telegram|telegram|on"
    "rust|rust|on"
    "py_36|python 3.6.15 (src install)|off"
    "py_38|python 3.8.19 (src install)|off"
    "py_dev_pkgs|python dev packages|on"
    "latest_pip|latest python pip|on"
    "qt_stuff|qtcreator + qt5|off"
    "imwheel|imwheel|off"
    "bt_restart|bt-restart|off"
    "ssh_alive|ssh-alive-settings|on"
    "ssh_skip_hosts_check|ssh-skip-hosts-check-settings|on"
    "solaar|solaar|on"
    "borgbackup_vorta|borgbackup + vorta gui|on"
    "spotify_spicetify|spotify + spicetify|off"
    "spotube|spotube|off"
    "fancontrol|fancontrol + config|on"
    "fastfetch|fastfetch|on"
)

# Parse arguments
ALL_OFF=false
for arg in "$@"; do
    [[ "$arg" == "--none" ]] && ALL_OFF=true
done

# Build options array for dialog/whiptail
options=()
for opt in "${ALL_OPTIONS[@]}"; do
    IFS='|' read -r key desc def <<< "$opt"
    if $ALL_OFF; then
        options+=("$key" "$desc" "off")
    else
        options+=("$key" "$desc" "$def")
    fi
done

cmd=("$dialog" --title "Automated packages installation" --backtitle "Mint Post Install" --separate-output --checklist "Select options:" 22 76 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]
then
    for choice in $choices
    do
        case $choice in
            personal_res)
                printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
                printf "${YELLOW}Installing aliases resources...\n${NC}"
                printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bash_aliases
                ;;
            sys_serial)
                printf "${YELLOW}Installing system permissions to allow user open Serial...\n${NC}"
                grep -Ei "^dialout" /etc/group;
                if [ $? -eq 0 ]; then
                    printf "${YELLOW}Dialout Group Exists add current user...\n${NC}"
                    if id -nG "$CURRENT_USER" | grep -qw "dialout"; then
                        printf "${YELLOW}User is already in dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
                    else
                        printf "${YELLOW}Add user to dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
                        sudo usermod -a -G dialout $CURRENT_USER
                    fi
                else
                    echo ""
                    printf "${RED}Dialout Group Not Exists can't add current user...\n${NC}"
                fi
                ;;
            xed_res)
                printf "${YELLOW}Installing Xed resources...\n${NC}"
                mkdir -p ~/.local/share/xed/styles/
                curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            gedit_res)
                printf "${YELLOW}Installing Gedit resources...\n${NC}"
                mkdir -p ~/.local/share/gedit/styles/
                curl -fsSLo ~/.local/share/gedit/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            sys_tweaks)
                printf "${YELLOW}System tweaks...\n${NC}"
                # ----> OUT
                # # Allow any user to mount umount without requiring user authentication.
                # ALL ALL = NOPASSWD:/usr/bin/mount
                # ALL ALL = NOPASSWD:/usr/bin/umount
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Allow any user to mount umount without requiring user authentication.\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                read -n 1 -s -r -p "Press any key to continue"
                sleep 3
                printf "\n${NC}"
                sudo bash -c "echo -e '# Allow any user to mount umount without requiring user authentication.\nALL ALL = NOPASSWD:/usr/bin/mount\nALL ALL = NOPASSWD:/usr/bin/umount' >> /etc/sudoers.d/mountumount"
                ;;
            sys_utils)
                printf "${YELLOW}Installing system utils...\n${NC}"
                sudo apt-get -y install bwm-ng screen htop bat
                mkdir -p ~/.local/bin
                ln -s /usr/bin/batcat ~/.local/bin/cat
                ;;
            cinnamon_spices)
                printf "${YELLOW}Installing cinnamon applets and extensions...\n${NC}"
                # cinnamon applet installer
                cd ~/.local/share/cinnamon/applets/

                printf "${LCYAN}- Applet QRedShift:\n${NC}"
                # QRedShift
                # This version is currently outdated and will no longer receive updates from the original author.
                # Using author official repository
                curl https://github.com/raphaelquintao/QRedshiftCinnamon/raw/master/install.sh -sSfL | bash 

                printf "${LCYAN}- Applet Bash Sensors:\n${NC}"
                # Bash Sensors
                curl -O https://cinnamon-spices.linuxmint.com/files/applets/bash-sensors@pkkk.zip && unzip bash-sensors@pkkk.zip && rm -rf bash-sensors@pkkk.zip
                sudo curl -fsSLo /usr/local/sbin/get-temps.sh https://raw.githubusercontent.com/AlessandroPerazzetta/cinnamon-applet-bash_sensors/main/get-temps.sh
                sudo chmod +x /usr/local/sbin/get-temps.sh

                printf "${LCYAN}- Applet Sensors Monitor:\n${NC}"
                # Sensors Monitor
                curl -O https://cinnamon-spices.linuxmint.com/files/applets/Sensors@claudiux.zip && unzip Sensors@claudiux.zip && rm -rf Sensors@claudiux.zip

                # cinnamon extensions installer
                cd ~/.local/share/cinnamon/extensions/

                printf "${LCYAN}- Applet Extension Back to Monitor:\n${NC}"
                # Back to Monitor
                curl -O https://cinnamon-spices.linuxmint.com/files/extensions/back-to-monitor@nathan818fr.zip && unzip back-to-monitor@nathan818fr.zip && rm -rf back-to-monitor@nathan818fr.zip

                printf "${LCYAN}- Applet Extension Cinnamon Dynamic Wallpaper:\n${NC}"
                # Cinnamon Dynamic Wallpaper
                curl -O https://cinnamon-spices.linuxmint.com/files/extensions/cinnamon-dynamic-wallpaper@TobiZog.zip && unzip cinnamon-dynamic-wallpaper@TobiZog.zip && rm -rf innamon-dynamic-wallpaper@TobiZog.zip

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Apply settings for spices using dconf or from applet/extension settings.\n\n"
                printf "\tExample:\n"
                printf "\t- dump: dconf dump: 'dconf dump / > dconf-root.conf'\n"
                printf "\t- load: dconf load: 'dconf load / < dconf-root.conf'\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                read -n 1 -s -r -p "Press any key to continue"
                sleep 3
                printf "\n${NC}"
                ;;
            nemo_actions)
                printf "${YELLOW}Installing custom Nemo Actions...\n${NC}"                
                mkdir -p ~/.local/share/nemo/actions/
                printf "${LCYAN}- Action: MKDTS\n${NC}"
                #bash -c "echo -e '# Custom action to create a dir with current timestamp\n[Nemo Action]\nName=MKDTS dir here\nComment=Create a dir with timestamp name\nExec=bash -c \"mkdir %F/$(date +%Y%m%d_%H%M)\"\nIcon-Name=inode-directory\nSelection=none\nExtensions=none\nDependencies=mkdir\nEscapeSpaces=true\nQuote=double' >> ~/.local/share/nemo/actions/mkdts.nemo_action"
                curl -fsSLo ~/.local/share/nemo/actions/mkdts.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/mint-post-install/main/nemo_actions/mkdts.nemo_action
                ;;
            neovim)
                printf "${YELLOW}Installing neovim...\n${NC}"
                sudo apt-get -y install neovim
                printf "${YELLOW}Installing neovim resources...\n${NC}"
                mkdir -p ~/.config/nvim/
                curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim
                printf "${YELLOW}Set nvim as default editor...\n${NC}"
                sudo update-alternatives --set editor /usr/bin/nvim
                printf "${YELLOW}Remove others editor...\n${NC}"
                sudo apt-get -y remove nano ed
                ;;
            filezilla)
                printf "${YELLOW}Installing filezilla...\n${NC}"
                sudo apt-get -y install filezilla
                ;;
            meld)
                printf "${YELLOW}Installing meld...\n${NC}"
                sudo apt-get -y install meld
                ;;
            vlc)
                printf "${YELLOW}Installing vlc...\n${NC}"
                sudo apt-get -y install vlc
                
                printf "${YELLOW}Installing vlc media library...\n${NC}"
                mkdir -p ~/.local/share/vlc/
                curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
                ;;
            kitty)
                printf "${YELLOW}Installing kitty...\n${NC}"
                sudo apt-get -y install kitty

                printf "${YELLOW}Set kitty as default terminal on cinnamon...\n${NC}"
                dconf write /org/cinnamon/desktop/applications/terminal/exec "'/usr/bin/kitty'"

                sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
                ;;
            kitty_res)
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
                ;;
            tmux)
                printf "${YELLOW}Installing tmux...\n${NC}"
                sudo apt-get -y install tmux
                ;;
            tmux_res)
                printf "${YELLOW}Installing tmux resources...\n${NC}"
                #curl -fsSLo ~/.tmux.conf https://raw.githubusercontent.com/AlessandroPerazzetta/dotfiles/main/.tmux.conf
                
                printf "${YELLOW}Installing tmux resources from git sparse checkout...\n${NC}"
                mkdir -p /tmp/dotfiles-tmux.git
                cd /tmp/dotfiles-tmux.git
                git init
                git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
                git sparse-checkout set tmux
                git pull origin main
                mv tmux ~/.config/
                cd -

                printf "${YELLOW}Fix system binding to run tmux on all terminals...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Backing up /usr/share/applications/kitty.desktop to /usr/share/applications/kitty.desktop.ORI : \n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                sudo cp /usr/share/applications/kitty.desktop /usr/share/applications/kitty.desktop.ORI

                ##### NOT needed due to global gsettings config #####
                # sudo sed -i -e "s/Exec=kitty/Exec=kitty -e tmux/g" /usr/share/applications/kitty.desktop

                ##### Original GNOME command #####
                # gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/kitty'
                # gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e tmux'
                
                ##### exec not working on cinnamon 21.3, need to create a bash to call full command #####
                ##### TOODO check on next cinnamon version #####
                # gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty -e tmux'
                ##### exec-arg not working on cinnamon, need to pass full command and args on exec #####
                # gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '-e tmux'
                
                # sudo bash -c "echo -e '' > /usr/bin/kitty-tmux"
                # sudo chmod +x /usr/bin/kitty-tmux
                # gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty-tmux'

                # release_number="$(cat /etc/issue | cut -d ' ' -f3|cut -f1 -d".")"
                # release_number="$(lsb_release -rs | cut -d. -f1|tr -d '\r\n')"

                if [[ ${RELEASE_NUMBER} -le 21 ]]; then
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
                    printf "Writing kitty tmux wrapper and set as default terminal application v21 and prior...\n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    sudo bash -c "echo -e '' > /usr/bin/kitty-tmux"
                    sudo chmod +x /usr/bin/kitty-tmux
                    gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty-tmux'
                elif [[ ${RELEASE_NUMBER} -ge 22 ]]; then
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
                    printf "Set kitty tmux gsettings as default terminal application v22 and later...\n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    gsettings set org.cinnamon.desktop.default-applications.terminal exec '/usr/bin/kitty -e tmux'
                else
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                    printf "Release number not recognized, skipping tmux wrapper/binding...\n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    sleep 5
                fi
                ;;
            brave)
                printf "${YELLOW}Installing brave-browser...\n${NC}"
                sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
                sudo apt-get update
                sudo apt-get -y install brave-browser
                ;;
            brave_ext)
                printf "${YELLOW}Installing brave-browser extensions...\n${NC}"
                BRAVE_PATH="/opt/brave.com/brave"
                BRAVE_EXTENSIONS_PATH="$BRAVE_PATH/extensions"
                if [ -d "$BRAVE_PATH" ]
                then
                    sudo mkdir -p ${BRAVE_EXTENSIONS_PATH}
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
                    )
                    for i in "${!EXTlist[@]}"; do
                        # echo "Key: $i value: ${EXTlist[$i]}"
                        # echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > /opt/google/chrome/extensions/${EXTlist[$i]}.json
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
                ;;
            remmina)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
                sudo apt-get update
                sudo apt-get -y install remmina remmina-plugin-rdp remmina-plugin-secret
                ;;
            vscodium)
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
                ;;
            vscode_nemo_actions)
                printf "${YELLOW}Installing nemo action for vscodium...\n${NC}"
                mkdir -p ~/.local/share/nemo/actions/
                curl -fsSLo ~/.local/share/nemo/actions/codium.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action
                ;;
            vscodium_ext)
                printf "${YELLOW}VSCodium extensions ...\n${NC}"
                if ! command -v codium &> /dev/null
                then
                    printf "${RED}Installing/Uninstalling vscodium extensions failed, codium could not be found...\n${NC}"
                else
                    printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
                    export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'
                    export VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'
                    export VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'
                    export VSCODE_GALLERY_CONTROL_URL=''
                    
                    # Extension removed from array:
                    #     Temporary removed, installed from file (v1.24.5) due to errors:
                    #     - https://github.com/VSCodium/vscodium/issues/2300
                    #     - https://github.com/getcursor/cursor/issues/2976
                    #    ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
                    printf "${LCYAN}Installing extension from file:\n${NC}"
                    mkdir -p /tmp/vscodium_exts/ && cd /tmp/vscodium_exts/
                    curl -s https://api.github.com/repos/jeanp413/open-remote-ssh/releases/latest | grep "browser_download_url.*vsix" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases/tags/v1.24.5 | grep "browser_download_url.*vsix"|grep "linux-x64" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    curl --compressed -fsSLo GitHub.copilot-1.257.1316.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/1.257.1316/vspackage
                    curl --compressed -fsSLo GitHub.copilot-chat-0.23.2024120501.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/0.23.2024120501/vspackage
                    find . -type f -name "*.vsix" -exec codium --install-extension {} --force --log debug \;

                    declare -A VSCODEEXTlistAdd=(
                        ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
                        ["Even Better TOML: Fully-featured TOML support"]="tamasfe.even-better-toml"
                        ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
                        ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
                        ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
                        ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
                        ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
                        ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
                        ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
                        ["isort: Import organization support for Python files using isort."]="ms-python.isort"
                        ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
                        ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
                        ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
                        ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
                        ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
                        ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
                        ["Dependi: Empowers developers to efficiently manage dependencies and address vulnerabilities in Rust, Go, JavaScript, Typescript, PHP and Python projects."]="fill-labs.dependi"
                        ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
                        ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
                        ["Todo Tree: Show TODO, FIXME, etc. comment tags in a tree view"]="Gruntfuggly.todo-tree"
                        ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
                        ["Readable Indent"]="cnojima.readable-indent"
                    )
                    for i in "${!VSCODEEXTlistAdd[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistAdd[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        codium --install-extension ${VSCODEEXTlistAdd[$i]} --force --log debug
                        printf "\n${NC}"
                    done

                    printf "${YELLOW}Uninstalling vscodium extensions ...\n${NC}"
                    declare -A VSCODEEXTlistDel=(
                        ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
                        ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
                        ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
                        ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
                        ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
                    )
                    for i in "${!VSCODEEXTlistDel[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistDel[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        codium --uninstall-extension ${VSCODEEXTlistDel[$i]} --log debug
                        printf "\n${NC}"
                    done
                fi
                ;;
            marktext)
                printf "${YELLOW}Installing Marktext editor...\n${NC}"
                sudo mkdir -p /opt/marktext/
                curl -s https://api.github.com/repos/marktext/marktext/releases/latest |grep "browser_download_url.*AppImage" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/marktext/marktext
                #sudo curl -fsSLo /opt/marktext/logo.png https://github.com/marktext/marktext/blob/b75895cdd1a51638f2e67b222b266ff8b9cb9d69/static/logo-96px.png
                sudo chmod +x /opt/marktext/marktext
                sudo bash -c "echo -e '[Desktop Entry]\nName=M\nGenericName=MQTT client\nComment=An all-round MQTT client that provides a structured topic overviewCategories=Development;\nTerminal=false\nType=Application\nPath=/opt/mqtt-explorer/\nExec=/opt/mqtt-explorer/mqtt-explorer\nStartupWMClass=mqtt-explorer\nStartupNotify=true\nKeywords=MQTT\nIcon=/opt/mqtt-explorer/icon.png' >> /usr/share/applications/mqtt-explorer.desktop"
                curl -L https://raw.githubusercontent.com/marktext/marktext/develop/resources/linux/marktext.desktop -o ~/.local/share/applications/marktext.desktop
                sed -i -e "s/Exec=marktext/Exec=\/opt\/marktext\/marktext/g" ~/.local/share/applications/marktext.desktop
                sed -i -e "s/Icon=marktext/Icon=\/opt\/marktext\/marktext/g" ~/.local/share/applications/marktext.desktop
                update-desktop-database ~/.local/share/applications/
                ;;
            dbeaver)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
                sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb
                ;;
            smartgit)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                sudo curl -fsSLo /tmp/smartgit-23_1_2.deb https://www.syntevo.com/downloads/smartgit/smartgit-23_1_2.deb
                sudo dpkg -i /tmp/smartgit-23_1_2.deb
                ;;
            mqtt_explorer)
                printf "${YELLOW}Installing MQTT-Explorer...\n${NC}"
                sudo mkdir -p /opt/mqtt-explorer/
                #curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -O -L
                #sudo chmod +x *.AppImage
                curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/mqtt-explorer/mqtt-explorer
                sudo chmod +x /opt/mqtt-explorer/mqtt-explorer
                sudo curl -L https://raw.githubusercontent.com/thomasnordquist/MQTT-Explorer/master/icon.png -o /opt/mqtt-explorer/icon.png
                # ----> OUT
                # [Desktop Entry]
                # Name=MQTT Explorer
                # GenericName=MQTT client
                # Comment=An all-round MQTT client that provides a structured topic overview
                # Categories=Development;
                # Terminal=false
                # Type=Application
                # Path=/opt/mqtt-explorer/
                # Exec=/opt/mqtt-explorer/mqtt-explorer
                # StartupWMClass=mqtt-explorer
                # StartupNotify=true
                # Keywords=MQTT
                # Icon=/opt/mqtt-explorer/icon.png
                sudo bash -c "echo -e '[Desktop Entry]\nName=MQTT Explorer\nGenericName=MQTT client\nComment=An all-round MQTT client that provides a structured topic overviewCategories=Development;\nTerminal=false\nType=Application\nPath=/opt/mqtt-explorer/\nExec=/opt/mqtt-explorer/mqtt-explorer\nStartupWMClass=mqtt-explorer\nStartupNotify=true\nKeywords=MQTT\nIcon=/opt/mqtt-explorer/icon.png' >> /usr/share/applications/mqtt-explorer.desktop"
                ;;
            arduino_cli)
                printf "${YELLOW}Installing arduino-cli...\n${NC}"
                sudo mkdir -p /opt/arduino-cli/
                sudo chown "$CURRENT_USER":"$CURRENT_USER" /opt/arduino-cli
                curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/opt/arduino-cli sh
                sudo ln -s /usr/bin/python3 /usr/bin/python
                ;;                
            keepassxc)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo apt-add-repository -y ppa:phoerious/keepassxc
                sudo apt-get update
                sudo apt-get -y install keepassxc
                ;;
            qownnotes)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                sudo apt-add-repository -y ppa:pbek/qownnotes
                sudo apt-get update
                sudo apt-get -y install qownnotes
                ;;
            virtualbox)
                printf "${YELLOW}Installing virtualbox...\n${NC}"
                curl -fSsL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null
                # echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                # Fixed codename
                # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                # os-release codename (get distro release codename, ex on mint return virginia)
                # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$VERSION_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                # lsb-release codename (get general release codename, ex on mint return jammy, that is ubuntu release codename base)
                # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/upstream-release/lsb-release && echo "$DISTRIB_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                # os-release ubuntu codename (get distro release codename, ex on mint return jammy)
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] https://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$UBUNTU_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                sudo apt-get update
                # sudo apt-get -y install virtualbox
                sudo apt-get -y install virtualbox-7.1
                sudo adduser $CURRENT_USER vboxusers
                sudo adduser $CURRENT_USER disk
                
                # printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                # printf "Please download virtualbox extension pack from here: \n"
                # printf "https://www.virtualbox.org/wiki/Downloads\n"
                # printf "and install manually from VirtualBox under File > Preferences > Extensions\n"
                # printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                # read -n 1 -s -r -p "Press any key to continue"
                # printf "\n${NC}"
                
                printf "${YELLOW}Installing virtualbox extension...\n${NC}"
                curl -O https://download.virtualbox.org/virtualbox/$(vboxmanage -v | cut -dr -f1)/Oracle_VirtualBox_Extension_Pack-$(vboxmanage -v | cut -dr -f1).vbox-extpack
                echo "y" | sudo vboxmanage extpack install Oracle_VirtualBox_Extension_Pack-$(vboxmanage -v | cut -dr -f1).vbox-extpack
                ;;
            kicad)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo apt-add-repository -y ppa:kicad/kicad-9.0-releases
                sudo apt-get update
                sudo apt-get -y install --install-recommends kicad
                ;;
            freecad)
                printf "${YELLOW}Installing freecad...\n${NC}"
                sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
                sudo apt-get update
                sudo apt-get -y install freecad
                ;;
            telegram)
                printf "${YELLOW}Installing telegram...\n${NC}"
                curl -fsSLo /tmp/Telegram.xz https://telegram.org/dl/desktop/linux
                sudo tar -xf /tmp/Telegram.xz -C /opt/
                ;;
            rust)
                printf "${YELLOW}Installing rust...\n${NC}"
                if ! command -v rustc &> /dev/null
                then
                    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                else
                    printf "${RED}Installing rust, rustc found. Rust already present...\n${NC}"
                fi
                ;;
            py_36)
                printf "${YELLOW}Installing python 3.6.15 (src install)...\n${NC}"
                sudo apt-get -y install build-essential checkinstall virtualenv
                sudo apt-get -y install libncurses-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
                cd /tmp
                sudo curl -O https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz
                sudo tar xzf Python-3.6.15.tgz
                cd Python-3.6.15
                sudo ./configure --enable-optimizations
                sudo make altinstall
                printf "${YELLOW}Installing multiple python...\n${NC}"
                sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
                sudo update-alternatives --install /usr/bin/python3.6 python3.6 /usr/local/bin/python3.6 36
                ;;
            py_38)
                printf "${YELLOW}Installing python 3.8.19 (src install)...\n${NC}"
                sudo apt-get -y install build-essential checkinstall virtualenv
                sudo apt-get -y install libncurses-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
                cd /tmp
                sudo curl -O https://www.python.org/ftp/python/3.8.19/Python-3.8.19.tgz
                sudo tar xzf Python-3.8.19.tgz
                cd Python-3.8.19
                sudo ./configure --enable-optimizations
                sudo make altinstall
                printf "${YELLOW}Installing multiple python...\n${NC}"
                sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
                sudo update-alternatives --install /usr/bin/python3.8 python3.8 /usr/local/bin/python3.8 38
                ;;
            py_dev_pkgs)
                printf "${YELLOW}Installing python dev packages...\n${NC}"
                sudo apt-get -y install python3-serial python3-pip python3-venv virtualenv
                sudo ln -s /usr/bin/python3 /usr/bin/python
                ;;
            latest_pip)
                printf "${YELLOW}Installing latest pip...\n${NC}"
                curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
                sudo -H python /tmp/get-pip.py --break-system-packages
                sudo ln -s /usr/local/bin/pip3 /usr/bin/pip3
                ;;
            qt_stuff)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo apt-get -y install cmake qtcreator qt5-default libqt5svg5* libqt5qml* libqt5xml* qtdeclarative5-dev
                ;;
            imwheel)
                printf "${YELLOW}Installing imwheel...\n${NC}"
                sudo apt-get -y install imwheel
                curl -fsSLo ~/mousewheel.sh https://raw.githubusercontent.com/AlessandroPerazzetta/imwheel/main/mousewheel.sh
                chmod +x ~/mousewheel.sh
                ~/mousewheel.sh
                ;;
            bt_restart)
                printf "${YELLOW}Installing bt-restart...\n${NC}"
                sudo curl -fsSLo /lib/systemd/system-sleep/bt https://raw.githubusercontent.com/AlessandroPerazzetta/bt-restart/main/bt
                sudo chmod +x /lib/systemd/system-sleep/bt
                ;;
            ssh_alive)
                printf "${YELLOW}Installing ssh alive settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE
                sudo sed -i -e "s/ServerAliveInterval 240/ServerAliveInterval 15/g" /etc/ssh/ssh_config
                sudo bash -c 'echo "    ServerAliveCountMax=1" >> /etc/ssh/ssh_config'
                ;;
            ssh_skip_hosts_check)
                printf "${YELLOW}Installing ssh skip hosts check settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS
                sudo bash -c 'echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
                sudo bash -c 'echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config'
                ;;
            solaar)
                printf "${YELLOW}Installing solaar (Logitech mouse support)...\n${NC}"
                sudo add-apt-repository -y ppa:solaar-unifying/stable
                sudo apt update
                sudo apt-get -y install solaar
                ;;
            borgbackup_vorta)
                printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
                sudo apt-get -y install borgbackup
                sudo apt-get -y install libxcb-cursor0
                sudo apt-get -y install python3-pyfuse3
                # sudo -H pip3 install vorta
                # sudo apt-get -y install vorta
                sudo pip3 install vorta --break-system-packages
                ;;
            spotify_spicetify)
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
                ;;
            spotube)
                printf "${YELLOW}Installing spotube...\n${NC}"
                sudo apt-get -y install mpv libjsoncpp25
                sudo curl -fsSLo /tmp/Spotube-linux-x86_64.deb https://github.com/KRTirtho/spotube/releases/download/v3.5.0/Spotube-linux-x86_64.deb
                sudo dpkg -i /tmp/Spotube-linux-x86_64.deb
                ;;     
            fancontrol)
                printf "${YELLOW}Installing fancontrol and config...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of fancontrol config if exist is available in /etc/fancontrol.ORIGINAL\n"
                printf "New settings can be made with pwmconfig\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo apt-get -y install fancontrol


                printf "${YELLOW}Adding restart on failure to fancontrol service...\n${NC}"
                if [[ -f /lib/systemd/system/fancontrol.service ]]; then
                    sudo cp /lib/systemd/system/fancontrol.service /lib/systemd/system/fancontrol.service.bak
                    sudo sed -i '/\[Service\]/a Restart=on-failure\nRestartSec=5s' /lib/systemd/system/fancontrol.service
                    sudo systemctl daemon-reload
                else
                    printf "${RED}Fancontrol service file not found\n${NC}"
                fi

                printf "${YELLOW}Backup fancontrol config...\n${NC}"
                if [[ -f /etc/fancontrol ]]; then
                    printf "/etc/fancontrol exists. Backup to /etc/fancontrol.ORIGINAL"
                    sudo mv /etc/fancontrol /etc/fancontrol.ORIGINAL
                fi
                
                printf "${YELLOW}Generating new fancontrol config...\n${NC}"
                release_number="$(cat /etc/issue | cut -d ' ' -f3|cut -f1 -d".")"
                if [[ ${release_number} -le "20" ]]; then
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
                    printf "Generating /etc/fancontrol files (Release number: Mint 20) \n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    # ----> OUT mint20
                    # #Configuration file generated by pwmconfig, changes will be lost
                    # INTERVAL=10
                    # DEVPATH=hwmon1=devices/platform/w83627ehf.656
                    # DEVNAME=hwmon1=nct6775
                    # FCTEMPS=hwmon1/device/pwm2=hwmon0/temp1_input hwmon1/device/pwm1=hwmon0/temp1_input
                    # FCFANS=hwmon1/device/pwm2=hwmon1/device/fan2_input hwmon1/device/pwm1=hwmon1/device/fan1_input
                    # MINTEMP=hwmon1/device/pwm2=20 hwmon1/device/pwm1=20
                    # MAXTEMP=hwmon1/device/pwm2=60 hwmon1/device/pwm1=60MINSTART=hwmon1/device/pwm2=150 hwmon1/device/pwm1=30
                    # MINSTOP=hwmon1/device/pwm2=0 hwmon1/device/pwm1=16
                    sudo bash -c "echo -e '# Configuration file generated by pwmconfig, changes will be lost\nINTERVAL=10\nDEVPATH=hwmon1=devices/platform/w83627ehf.656\nDEVNAME=hwmon1=nct6775\nFCTEMPS=hwmon1/device/pwm2=hwmon0/temp1_input hwmon1/device/pwm1=hwmon0/temp1_input\nFCFANS=hwmon1/device/pwm2=hwmon1/device/fan2_input hwmon1/device/pwm1=hwmon1/device/fan1_input\nMINTEMP=hwmon1/device/pwm2=20 hwmon1/device/pwm1=20\nMAXTEMP=hwmon1/device/pwm2=60 hwmon1/device/pwm1=60MINSTART=hwmon1/device/pwm2=150 hwmon1/device/pwm1=30\nMINSTOP=hwmon1/device/pwm2=0 hwmon1/device/pwm1=16' >> /etc/fancontrol"
                elif [[ ${release_number} -ge "21" ]]; then
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${PURPLE}"
                    printf "Generating /etc/fancontrol files (Release number: Mint 21) \n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    # ----> OUT mint21
                    
                    # New settings for Mint >=21 Asus P8Z77-V-LX2 Motherboard

                    ####################################################
                    # File: /etc/fancontrol.hwmon2
                    ####################################################
                    # # Configuration file generated by pwmconfig, changes will be lost
                    # INTERVAL=10
                    # DEVPATH=hwmon1=devices/platform/coretemp.0 hwmon2=devices/platform/nct6775.656
                    # DEVNAME=hwmon1=coretemp hwmon2=nct6779
                    # FCTEMPS=hwmon2/pwm1=hwmon1/temp1_input hwmon2/pwm2=hwmon1/temp1_input hwmon2/pwm3=hwmon1/temp1_input
                    # FCFANS=hwmon2/pwm1=hwmon2/fan1_input hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm3=hwmon2/fan3_input
                    # MINTEMP=hwmon2/pwm1=40 hwmon2/pwm2=40 hwmon2/pwm3=40
                    # MAXTEMP=hwmon2/pwm1=85 hwmon2/pwm2=85 hwmon2/pwm3=85
                    # MINSTART=hwmon2/pwm1=75 hwmon2/pwm2=150 hwmon2/pwm3=90
                    # MINSTOP=hwmon2/pwm1=60 hwmon2/pwm2=0 hwmon2/pwm3=75
                    #
                    # Note: hwmon1 is coretemp, hwmon2 is nct6779
                    #       hwmon2/pwm1 is fan1, hwmon2/pwm2 is fan2, hwmon2/pwm3 is fan3
                    #       hwmon1/temp1_input is the temperature sensor used for all fans (core package temperature)
                    # Found the following devices:
                    # hwmon1 is coretemp
                    # hwmon2 is nct6779
                    #
                    # FAN PWM
                    # hwmon2/pwm1
                    # hwmon2/pwm2
                    # hwmon2/pwm3
                    sudo bash -c "echo -e '# Configuration file generated by pwmconfig, changes will be lost\nINTERVAL=10\nDEVPATH=hwmon1=devices/platform/coretemp.0 hwmon2=devices/platform/nct6775.656\nDEVNAME=hwmon1=coretemp hwmon2=nct6779\nFCTEMPS=hwmon2/pwm1=hwmon1/temp1_input hwmon2/pwm2=hwmon1/temp1_input hwmon2/pwm3=hwmon1/temp1_input\nFCFANS=hwmon2/pwm1=hwmon2/fan1_input hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm3=hwmon2/fan3_input\nMINTEMP=hwmon2/pwm1=40 hwmon2/pwm2=40 hwmon2/pwm3=40\nMAXTEMP=hwmon2/pwm1=85 hwmon2/pwm2=85 hwmon2/pwm3=85\nMINSTART=hwmon2/pwm1=75 hwmon2/pwm2=150 hwmon2/pwm3=90\nMINSTOP=hwmon2/pwm1=60 hwmon2/pwm2=0 hwmon2/pwm3=75\n' >> /etc/fancontrol.hwmon2"
                    ####################################################
                    # File: /etc/fancontrol.hwmon3
                    ####################################################
                    # # Configuration file generated by pwmconfig, changes will be lost
                    # INTERVAL=15
                    # DEVPATH=hwmon2=devices/platform/coretemp.0 hwmon3=devices/platform/nct6775.656
                    # DEVNAME=hwmon2=coretemp hwmon3=nct6779
                    # FCTEMPS=hwmon3/pwm1=hwmon2/temp1_input hwmon3/pwm2=hwmon2/temp1_input hwmon3/pwm3=hwmon2/temp1_input
                    # FCFANS=hwmon3/pwm1=hwmon3/fan1_input hwmon3/pwm2=hwmon3/fan2_input+hwmon3/fan1_input hwmon3/pwm3=hwmon3/fan3_input
                    # MINTEMP=hwmon3/pwm1=40 hwmon3/pwm2=40 hwmon3/pwm3=40
                    # MAXTEMP=hwmon3/pwm1=85 hwmon3/pwm2=85 hwmon3/pwm3=85
                    # MINSTART=hwmon3/pwm1=75 hwmon3/pwm2=150 hwmon3/pwm3=105
                    # MINSTOP=hwmon3/pwm1=60 hwmon3/pwm2=0 hwmon3/pwm3=90
                    #
                    # Note: hwmon2 is coretemp, hwmon3 is nct6779
                    #       hwmon3/pwm1 is fan1, hwmon3/pwm2 is fan2, hwmon3/pwm3 is fan3
                    #       hwmon2/temp1_input is the temperature sensor used for all fans (core package temperature)
                    # Found the following devices:
                    # hwmon2 is coretemp
                    # hwmon3 is nct6779
                    #
                    # FAN PWM
                    # hwmon3/pwm1
                    # hwmon3/pwm2
                    # hwmon3/pwm3
                    sudo bash -c "echo -e '# Configuration file generated by pwmconfig, changes will be lost\nINTERVAL=10\nDEVPATH=hwmon2=devices/platform/coretemp.0 hwmon3=devices/platform/nct6775.656\nDEVNAME=hwmon2=coretemp hwmon3=nct6779\nFCTEMPS=hwmon3/pwm1=hwmon2/temp1_input hwmon3/pwm2=hwmon2/temp1_input hwmon3/pwm3=hwmon2/temp1_input\nFCFANS=hwmon3/pwm1=hwmon3/fan1_input hwmon3/pwm2=hwmon3/fan2_input hwmon3/pwm3=hwmon3/fan3_input\nMINTEMP=hwmon3/pwm1=40 hwmon3/pwm2=40 hwmon3/pwm3=40\nMAXTEMP=hwmon3/pwm1=85 hwmon3/pwm2=85 hwmon3/pwm3=85\nMINSTART=hwmon3/pwm1=75 hwmon3/pwm2=150 hwmon3/pwm3=105\nMINSTOP=hwmon3/pwm1=60 hwmon3/pwm2=0 hwmon3/pwm3=90\n' >> /etc/fancontrol.hwmon3"
                else
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                    printf "Not generating /etc/fancontrol files (Release number: Not recognized) \n"
                    printf "Try to generate new settings with pwmconfig\n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                fi

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Adding hardware in /etc/modules: \n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                sudo bash -c "echo -e 'coretemp\nw83627ehf\nnct6775\n' >> /etc/modules"

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Please restart system and check fancontrol.service\n"
                printf "If service is not started run: sudo pwmconfig and follow the wizard\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                read -n 1 -s -r -p "Press any key to continue"
                sleep 3
                printf "\n${NC}"
                ;;
            fastfetch)
                printf "${YELLOW}Installing fastfetch...\n${NC}"
                curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest |grep "browser_download_url.*linux-amd64.deb" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /tmp/fastfetch-latest-linux-amd64.deb
                sudo dpkg -i /tmp/fastfetch-latest-linux-amd64.deb
                ;;     
        esac
    done
else
        exit 0
fi
