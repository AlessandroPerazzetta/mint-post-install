#!/bin/bash
CURRENT_USER=$(whoami)

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

cmd=(dialog --title "Automated packages installation" --backtitle "Mint Post Install" --no-collapse --separate-output --checklist "Select options:" 22 76 16)
options=(
0 "Personal resources" on
1 "System Serial permission" on
2 "Xed theme resources" on
3 "Gedit theme resources" off
4 "System tewaks" on
5 "bwm-ng" on
6 "screen" on
7 "neovim" on
8 "filezilla" on
9 "meld" on
10 "vlc" on
11 "git" on
12 "htop" on
13 "brave-browser" on
14 "brave-browser extensions" on
15 "remmina" on
16 "vscodium" on
17 "vscodium extensions" on
18 "marktext" on
19 "dbeaver" on
20 "smartgit" on
21 "mqtt-explorer" on
22 "arduino-cli" on
23 "keepassxc" on
24 "qownnotes" on
25 "virtualbox" on
26 "kicad" on
27 "freecad" on
28 "telegram" on
29 "rust" on
30 "python 3.6.15 (src install)" off
31 "python 3.8 (pkg install)" off
32 "qtcreator + qt5" off
33 "imwheel" off
34 "bt-restart" off
35 "ssh-alive-settings" on
36 "solaar" on
37 "borgbackup + vorta gui" on
38 "spotify + spicetify" off
39 "spotube" off
40 "fancontrol + config" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]
then
    printf "${YELLOW}Updating system...\n${NC}"
    sleep 1
    sudo apt update
    sudo apt upgrade

    printf "${YELLOW}Install required packages...\n${NC}"
    sleep 1
    sudo apt -y install build-essential apt-transport-https curl python3-serial python3-pip sshfs dialog

    for choice in $choices
    do
        case $choice in
            0)
                printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
                printf "${YELLOW}Installing aliase resources...\n${NC}"
                printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bash_aliases
                ;;
            1)
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
            2)
                printf "${YELLOW}Installing Xed resources...\n${NC}"
                mkdir -p ~/.local/share/xed/styles/
                curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            3)
                printf "${YELLOW}Installing Gedit resources...\n${NC}"
                mkdir -p ~/.local/share/gedit/styles/
                curl -fsSLo ~/.local/share/gedit/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            4)
                printf "${YELLOW}System tweaks...\n${NC}"
                # ----> OUT
                # # Allow any user to mount umount without requiring user authentication.
                # ALL ALL = NOPASSWD:/usr/bin/mount
                # ALL ALL = NOPASSWD:/usr/bin/umount
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Allow any user to mount umount without requiring user authentication.\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                read -n 1 -s -r -p "Press any key to continue"
                printf "\n${NC}"
                sudo bash -c "echo -e '# Allow any user to mount umount without requiring user authentication.\nALL ALL = NOPASSWD:/usr/bin/mount\nALL ALL = NOPASSWD:/usr/bin/umount' >> /etc/sudoers.d/mountumount"
                ;;
            5)
                printf "${YELLOW}Installing bwm-ng...\n${NC}"
                sudo apt -y install bwm-ng
                ;;
            6)
                printf "${YELLOW}Installing screen...\n${NC}"
                sudo apt -y install screen
                ;;
            7)
                printf "${YELLOW}Installing neovim...\n${NC}"
                sudo apt -y install neovim

                printf "${YELLOW}Installing neovim resources...\n${NC}"
                mkdir -p ~/.config/nvim/
                curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim

                printf "${YELLOW}Set nvim as default editor...\n${NC}"
                sudo update-alternatives --set editor /usr/bin/nvim

                printf "${YELLOW}Remove others editor...\n${NC}"
                sudo apt -y remove nano ed
                ;;
            8)
                printf "${YELLOW}Installing filezilla...\n${NC}"
                sudo apt -y install filezilla
                ;;
            9)
                printf "${YELLOW}Installing meld...\n${NC}"
                sudo apt -y install meld
                ;;
            10)
                printf "${YELLOW}Installing vlc...\n${NC}"
                sudo apt -y install vlc
                
                printf "${YELLOW}Installing vlc media library...\n${NC}"
                mkdir -p ~/.local/share/vlc/
                curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
                ;;
            11)
                printf "${YELLOW}Installing git...\n${NC}"
                sudo apt -y install git
                ;;
            12)
                printf "${YELLOW}Installing htop...\n${NC}"
                sudo apt -y install htop
                ;;
            13)
                printf "${YELLOW}Installing brave-browser...\n${NC}"
                sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
                sudo apt update
                sudo apt -y install brave-browser
                ;;
            14)
                printf "${YELLOW}Installing brave-browser extensions...\n${NC}"
                BRAVE_PATH="/opt/brave.com/brave"
                BRAVE_EXTENSIONS_PATH="$BRAVE_PATH/extensions"
                if [ -d "$BRAVE_PATH" ]
                then
                    sudo mkdir -p ${BRAVE_EXTENSIONS_PATH}
                    declare -A EXTlist=(
                        ["bypass-adblock-detection"]="lppagnomjcaohgkfljlebenbmbdmbkdj"
                        ["hls-downloader"]="hkbifmjmkohpemgdkknlbgmnpocooogp"
                        ["i-dont-care-about-cookies"]="fihnjjcciajhdojfnbdddfaoknhalnja"
                        ["keepassxc-browser"]="oboonakemofpalcgghocfoadofidjkkk"
                        ["session-buddy"]="edacconmaakjimmfgnblocblbcdcpbko"
                        ["the-marvellous-suspender"]="noogafoofpebimajpfpamcfhoaifemoa"
                        ["url-tracking-stripper-red"]="flnagcobkfofedknnnmofijmmkbgfamf"
                        ["video-downloader-plus"]="njgehaondchbmjmajphnhlojfnbfokng"
                        ["stream-cleaner"]="lehcglgkjkamolcflammloedahjocbbg"
                        
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
                    printf "\n${NC}"
                fi
                ;;
            15)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
                sudo apt update
                sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret
                ;;
            16)
                printf "${YELLOW}Installing vscodium...\n${NC}"
                wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
                echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
                sudo apt update && sudo apt -y install codium jq

                # OLD Script to replace marketplace in extensionsGallery on products.json
                # printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
                # cd /usr/local/sbin/
                # sudo git clone https://github.com/AlessandroPerazzetta/vscodium-json-updater
                # cd -
                # sudo /usr/local/sbin/vscodium-json-updater/update.sh

                # NEW Script to replace marketplace in extensionsGallery on products.json (local user config)
                mkdir -p ~/.config/VSCodium/
                bash -c "echo -e '{\n  \"nameShort\": \"Visual Studio Code\",\n  \"nameLong\": \"Visual Studio Code\",\n  \"extensionsGallery\": {\n    \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",\n    \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",\n    \"itemUrl\": \"https://marketplace.visualstudio.com/items\"\n  }\n}\n' > ~/.config/VSCodium/product.json"
  
                printf "${YELLOW}Installing nemo action for vscodium...\n${NC}"
                #sudo wget https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action -O ~/.local/share/nemo/actions/codium.nemo_action
                mkdir -p ~/.local/share/nemo/actions/
                curl -fsSLo ~/.local/share/nemo/actions/codium.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action
                ;;
            17)
                printf "${YELLOW}VSCodium extensions ...\n${NC}"
                if ! command -v codium &> /dev/null
                then
                    printf "${RED}Installing/Uninstalling vscodium extensions failed, codium could not be found...\n${NC}"
                else
                    printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
                    codium --install-extension bungcip.better-toml
                    codium --install-extension rust-lang.rust-analyzer
                    codium --install-extension jinxdash.prettier-rust
                    codium --install-extension kogia-sima.vscode-sailfish
                    codium --install-extension ms-python.python
                    codium --install-extension ms-python.vscode-pylance
                    codium --install-extension ms-vscode.cpptools
                    codium --install-extension serayuzgur.crates
                    codium --install-extension usernamehw.errorlens
                    codium --install-extension vadimcn.vscode-lldb
                    codium --install-extension vsciot-vscode.vscode-arduino
                    codium --install-extension jeff-hykin.better-cpp-syntax
                    codium --install-extension aaron-bond.better-comments
                    codium --install-extension ahmadawais.shades-of-purple
                    codium --install-extension kamikillerto.vscode-colorize
                    printf "${YELLOW}Uninstalling vscodium extensions ...\n${NC}"
                    codium --uninstall-extension ms-toolsai.jupyter
                    codium --uninstall-extension ms-toolsai.jupyter-keymap
                    codium --uninstall-extension ms-toolsai.jupyter-renderers
                    codium --uninstall-extension ms-toolsai.vscode-jupyter-cell-tags
                    codium --uninstall-extension ms-toolsai.vscode-jupyter-slideshow
                fi
                ;;
            18)
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
            19)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
                sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb
                ;;
            20)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                sudo curl -fsSLo /tmp/smartgit-23_1_1.deb https://www.syntevo.com/downloads/smartgit/smartgit-23_1_1.deb
                sudo dpkg -i /tmp/smartgit-23_1_1.deb
                ;;
            21)
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
            22)
                printf "${YELLOW}Installing arduino-cli...\n${NC}"
                sudo mkdir -p /opt/arduino-cli/
                sudo chown "$CURRENT_USER":"$CURRENT_USER" /opt/arduino-cli
                curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/opt/arduino-cli sh
                ;;                
            23)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo apt-add-repository -y ppa:phoerious/keepassxc
                sudo apt update
                sudo apt -y install keepassxc
                ;;
            24)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                sudo apt-add-repository -y ppa:pbek/qownnotes
                sudo apt update
                sudo apt -y install qownnotes
                ;;
            25)
                printf "${YELLOW}Installing virtualbox...\n${NC}"
                sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
                echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
                sudo apt update
                sudo apt -y install virtualbox
                sudo adduser $CURRENT_USER vboxusers
                sudo adduser $CURRENT_USER disk
                
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Please download virtualbox extension pack from here: \n"
                printf "https://www.virtualbox.org/wiki/Downloads\n"
                printf "and install manually from VirtualBox under File > Preferences > Extensions\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                read -n 1 -s -r -p "Press any key to continue"
                printf "\n${NC}"
                ;;
            26)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo apt-add-repository -y ppa:kicad/kicad-5.1-releases
                sudo apt update
                sudo apt -y install --install-recommends kicad
                ;;
            27)
                printf "${YELLOW}Installing freecad...\n${NC}"
                sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
                sudo apt update
                sudo apt -y install freecad
                ;;
            28)
                printf "${YELLOW}Installing telegram...\n${NC}"
                curl -fsSLo /tmp/Telegram.xz https://telegram.org/dl/desktop/linux
                sudo tar -xf /tmp/Telegram.xz -C /opt/
                ;;
            29)
                printf "${YELLOW}Installing rust...\n${NC}"
                if ! command -v rustc &> /dev/null
                then
                    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                else
                    printf "${RED}Installing rust, rustc found. Rust already present...\n${NC}"
                fi
                ;;
            30)
                printf "${YELLOW}Installing python 3.6.15 (src install)...\n${NC}"
                sudo apt -y install build-essential checkinstall virtualenv
                sudo apt -y install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
                cd /tmp
                sudo wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz
                sudo tar xzf Python-3.6.15.tgz
                cd Python-3.6.15
                sudo ./configure --enable-optimizations
                sudo make altinstall
                printf "${YELLOW}Installing multiple python...\n${NC}"
                sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
                sudo update-alternatives --install /usr/bin/python3.6 python3.6 /usr/local/bin/python3.6 2
                ;;
            31)
                printf "${YELLOW}Installing python 3.8 (pkg install)...\n${NC}"
                sudo apt -y install python3.8{-distutils,-venv}
                printf "${YELLOW}Installing multiple python...\n${NC}"
                sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
                printf "${YELLOW}Installing last pip...\n${NC}"
                curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
                sudo -H python /tmp/get-pip.py 
                sudo ln -s /usr/local/bin/pip3 /usr/bin/pip3
                ;;
            32)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo apt -y install cmake qtcreator qt5-default libqt5svg5* libqt5qml* libqt5xml* qtdeclarative5-dev
                ;;
            33)
                printf "${YELLOW}Installing imwheel...\n${NC}"
                sudo apt -y install imwheel
                curl -fsSLo ~/mousewheel.sh https://raw.githubusercontent.com/AlessandroPerazzetta/imwheel/main/mousewheel.sh
                chmod +x ~/mousewheel.sh
                ~/mousewheel.sh
                ;;
            34)
                printf "${YELLOW}Installing bt-restart...\n${NC}"
                sudo curl -fsSLo /lib/systemd/system-sleep/bt https://raw.githubusercontent.com/AlessandroPerazzetta/bt-restart/main/bt
                sudo chmod +x /lib/systemd/system-sleep/bt
                ;;
            35)
                printf "${YELLOW}Installing ssh alive settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL
                sudo sed -i -e "s/ServerAliveInterval 240/ServerAliveInterval 15/g" /etc/ssh/ssh_config
                sudo bash -c 'echo "    ServerAliveCountMax=1" >> /etc/ssh/ssh_config'
                ;;
            36)
                printf "${YELLOW}Installing solaar (Logitech mouse support)...\n${NC}"
                sudo apt -y install solaar
                ;;
            37)
                printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
                sudo apt -y install borgbackup
                sudo -H pip3 install vorta
                ;;
            38)
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
            39)
                printf "${YELLOW}Installing spotube...\n${NC}"
                sudo mkdir -p /opt/spotube
                sudo chmod a+wr /opt/spotube
                sudo curl -fsSLo /opt/spotube/Spotube-linux-x86_64.AppImage https://github.com/KRTirtho/spotube/releases/latest/download/Spotube-linux-x86_64.AppImage
                sudo chmod +x /opt/spotube/Spotube-linux-x86_64.AppImage                
                curl -fsSLo /opt/spotube/Spotube-linux-x86_64.png https://github.com/KRTirtho/spotube/blob/master/assets/spotube-logo.png?raw=true
                # ----> OUT
                # [Desktop Entry]
                # Name=Spotube
                # GenericName=Spotube
                # Comment=A music streaming app combining the power of Spotify & YouTube
                # Categories=Audio;Music;Player;AudioVideo;
                # Terminal=false
                # Type=Application
                # Path=/opt/spotube/
                # Exec=/opt/spotube/Spotube-linux-x86_64.AppImage
                # StartupWMClass=Spotube-linux-x86_64.AppImage
                # StartupNotify=true
                # Keywords=Spotube
                # Icon=/opt/spotube/Spotube-linux-x86_64.png
                sudo bash -c "echo -e '[Desktop Entry]\nName=Spotube\nGenericName=Spotube\nComment=A music streaming app combining the power of Spotify & YouTube\nCategories=Audio;Music;Player;AudioVideo;\nTerminal=false\nType=Application\nPath=/opt/spotube/\nExec=/opt/spotube/Spotube-linux-x86_64.AppImage\nStartupWMClass=Spotube-linux-x86_64.AppImage\nStartupNotify=true\nKeywords=Spotube\nIcon=/opt/spotube/Spotube-linux-x86_64.png'  >> /usr/share/applications/spotube.desktop"
                ;;     
            40)
                printf "${YELLOW}Installing fancontrol and config...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of fancontrol config if exist is available in /etc/fancontrol.ORIGINAL\n"
                printf "New settings can be made with pwmconfig"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo apt -y install fancontrol
                if [[ -f /etc/fancontrol ]]; then
                    echo "/etc/fancontrol exists. Backup to /etc/fancontrol.ORIGINAL"
                    sudo mv /etc/fancontrol /etc/fancontrol.ORIGINAL
                fi

                # ----> OUT
                # Configuration file generated by pwmconfig, changes will be lost
                # INTERVAL=10
                # DEVPATH=hwmon1=devices/platform/w83627ehf.656
                # DEVNAME=hwmon1=nct6775
                # FCTEMPS=hwmon1/device/pwm2=hwmon0/temp1_input hwmon1/device/pwm1=hwmon0/temp1_input
                # FCFANS=hwmon1/device/pwm2=hwmon1/device/fan2_input hwmon1/device/pwm1=hwmon1/device/fan1_input
                # MINTEMP=hwmon1/device/pwm2=20 hwmon1/device/pwm1=20
                # MAXTEMP=hwmon1/device/pwm2=60 hwmon1/device/pwm1=60MINSTART=hwmon1/device/pwm2=150 hwmon1/device/pwm1=30
                # MINSTOP=hwmon1/device/pwm2=0 hwmon1/device/pwm1=16
                sudo bash -c "echo -e '# Configuration file generated by pwmconfig, changes will be lost\nINTERVAL=10\nDEVPATH=hwmon1=devices/platform/w83627ehf.656\nDEVNAME=hwmon1=nct6775\nFCTEMPS=hwmon1/device/pwm2=hwmon0/temp1_input hwmon1/device/pwm1=hwmon0/temp1_input\nFCFANS=hwmon1/device/pwm2=hwmon1/device/fan2_input hwmon1/device/pwm1=hwmon1/device/fan1_input\nMINTEMP=hwmon1/device/pwm2=20 hwmon1/device/pwm1=20\nMAXTEMP=hwmon1/device/pwm2=60 hwmon1/device/pwm1=60MINSTART=hwmon1/device/pwm2=150 hwmon1/device/pwm1=30\nMINSTOP=hwmon1/device/pwm2=0 hwmon1/device/pwm1=16' >> /etc/fancontrol"                
                ;;
        esac
    done
else
        exit 0
fi