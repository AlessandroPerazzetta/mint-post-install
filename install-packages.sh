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
1 "bwm-ng" on
2 "screen" on
3 "neovim" on
4 "filezilla" on
5 "meld" on
6 "vlc" on
7 "git" on
8 "htop" on
9 "brave-browser" on
10 "remmina" on
11 "vscodium" on
12 "vscodium extensions" on
13 "dbeaver" on
14 "smartgit" on
15 "mqtt-explorer" on
16 "keepassxc" on
17 "qownnotes" on
18 "virtualbox" on
19 "kicad" on
20 "freecad" on
21 "telegram" on
22 "rust" on
23 "python 3.6.15 (src install)" off
24 "qtcreator + qt5" off
25 "imwheel" off
26 "bt-restart" off
27 "ssh-alive-settings" on
28 "borgbackup + vorta gui" on
29 "spotify + spicetify" off)

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
    sudo apt -y install build-essential apt-transport-https curl python3-serial

    if id -nG "$CURRENT_USER" | grep -qw "dialout"; then
        printf "${YELLOW}User is already in dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
    else
        printf "${YELLOW}Add user to dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
        sudo usermod -a -G dialout $CURRENT_USER
    fi

    for choice in $choices
    do
        case $choice in
            0)
                printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
                printf "${YELLOW}Installing aliase resources...\n${NC}"
                printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bash_aliases
                printf "${YELLOW}Installing Xed resources...\n${NC}"
                mkdir -p ~/.local/share/xed/styles/
                curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            1)
                printf "${YELLOW}Installing bwm-ng...\n${NC}"
                sudo apt -y install bwm-ng
                ;;
            2)
                printf "${YELLOW}Installing screen...\n${NC}"
                sudo apt -y install screen
                ;;
            3)
                printf "${YELLOW}Installing neovim...\n${NC}"
                sudo apt -y install neovim

                printf "${YELLOW}Installing neovim resources...\n${NC}"
                mkdir -p ~/.config/nvim/
                curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim

                printf "${YELLOW}Set nvim as default editor...\n${NC}"
                update-alternatives --set editor /usr/bin/nvim

                printf "${YELLOW}Remove others editor...\n${NC}"
                sudo apt -y remove nano ed
                ;;
            4)
                printf "${YELLOW}Installing filezilla...\n${NC}"
                sudo apt -y install filezilla
                ;;
            5)
                printf "${YELLOW}Installing meld...\n${NC}"
                sudo apt -y install meld
                ;;
            6)
                printf "${YELLOW}Installing vlc...\n${NC}"
                sudo apt -y install vlc
                
                printf "${YELLOW}Installing vlc media library...\n${NC}"
                mkdir -p ~/.local/share/vlc/
                curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
                ;;
            7)
                printf "${YELLOW}Installing git...\n${NC}"
                sudo apt -y install git
                ;;
            8)
                printf "${YELLOW}Installing htop...\n${NC}"
                sudo apt -y install htop
                ;;
            9)
                printf "${YELLOW}Installing brave-browser...\n${NC}"
                sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
                sudo apt update
                sudo apt -y install brave-browser
                ;;
            10)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo apt-add-repository -y ppa:remmina-ppa-team/remmina-next
                sudo apt update
                sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret
                ;;
            11)
                printf "${YELLOW}Installing vscodium...\n${NC}"
                wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
                echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
                sudo apt update && sudo apt -y install codium jq

                printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
                cd /usr/local/sbin/
                sudo git clone https://github.com/AlessandroPerazzetta/vscodium-json-updater
                cd -
                sudo /usr/local/sbin/vscodium-json-updater/update.sh

                printf "${YELLOW}Installing nemo action for vscodium...\n${NC}"
                sudo wget https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action -O ~/.local/share/nemo/actions/codium.nemo_action
                ;;
            12)
                printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
                codium --install-extension bungcip.better-toml
                codium --install-extension rust-lang.rust-analyzer
                codium --install-extension ms-python.python
                codium --install-extension ms-python.vscode-pylance
                codium --install-extension ms-vscode.cpptools
                codium --install-extension serayuzgur.crates
                codium --install-extension usernamehw.errorlens
                codium --install-extension vadimcn.vscode-lldb
                codium --install-extension vsciot-vscode.vscode-arduino
                ;;
            13)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
                sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb
                ;;
            14)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                sudo curl -fsSLo /tmp/smartgit-21_2_0.deb https://www.syntevo.com/downloads/smartgit/smartgit-21_2_0.deb
                sudo dpkg -i /tmp/smartgit-21_2_0.deb
                ;;
            15)
                printf "${YELLOW}Installing MQTT-Explorer...\n${NC}"
                sudo mkdir -p /opt/mqtt-explorer/
                #curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -O -L
                #sudo chmod +x *.AppImage
                curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest |grep "browser_download_url.*AppImage" |grep -Ewv 'armv7l|i386' |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/mqtt-explorer/mqtt-explorer
                sudo chmod +x /opt/mqtt-explorer/mqtt-explorer
                sudo curl -L https://raw.githubusercontent.com/thomasnordquist/MQTT-Explorer/master/icon.png -o /opt/mqtt-explorer/icon.png
                sudo bash -c 'cat <<EOT >> /usr/share/applications/mqtt-explorer.desktop
                [Desktop Entry]
                Name=MQTT Explorer
                GenericName=MQTT client
                Comment=An all-round MQTT client that provides a structured topic overview
                Categories=Development;
                Terminal=false
                Type=Application
                Path=/opt/mqtt-explorer/
                Exec=/opt/mqtt-explorer/mqtt-explorer
                StartupWMClass=mqtt-explorer
                StartupNotify=true
                Keywords=MQTT
                Icon=/opt/mqtt-explorer/icon.png
                EOT'
                ;;
            16)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo apt-add-repository -y ppa:phoerious/keepassxc
                sudo apt update
                sudo apt -y install keepassxc
                ;;
            17)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                sudo apt-add-repository -y ppa:pbek/qownnotes
                sudo apt update
                sudo apt -y install qownnotes
                ;;
            18)
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
            19)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo apt-add-repository -y ppa:kicad/kicad-5.1-releases
                sudo apt update
                sudo apt -y install --install-recommends kicad
                ;;
            20)
                printf "${YELLOW}Installing freecad...\n${NC}"
                sudo add-apt-repository -y ppa:freecad-maintainers/freecad-stable
                sudo apt update
                sudo apt -y install freecad
                ;;
            21)
                printf "${YELLOW}Installing telegram...\n${NC}"
                curl -fsSLo /tmp/Telegram.xz https://telegram.org/dl/desktop/linux
                sudo tar -xf /tmp/Telegram.xz -C /opt/
                ;;
            22)
                printf "${YELLOW}Installing rust...\n${NC}"
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                ;;
            23)
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
            24)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo apt -y install cmake qtcreator qt5-default libqt5svg5* libqt5qml* libqt5xml* qtdeclarative5-dev
                ;;
            25)
                printf "${YELLOW}Installing imwheel...\n${NC}"
                sudo apt -y install imwheel
                curl -fsSLo ~/mousewheel.sh https://raw.githubusercontent.com/AlessandroPerazzetta/imwheel/main/mousewheel.sh
                chmod +x ~/mousewheel.sh
                ~/mousewheel.sh
                ;;
            26)
                printf "${YELLOW}Installing bt-restart...\n${NC}"
                sudo curl -fsSLo /lib/systemd/system-sleep/bt https://raw.githubusercontent.com/AlessandroPerazzetta/bt-restart/main/bt
                sudo chmod +x /lib/systemd/system-sleep/bt
                ;;
            27)
                printf "${YELLOW}Installing ssh alive settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"                
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL
                sudo sed -i -e "s/ServerAliveInterval 240/ServerAliveInterval 15/g" /etc/ssh/ssh_config
                sudo bash -c 'echo "    ServerAliveCountMax=1" >> /etc/ssh/ssh_config'
                ;;
            28)
                printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
                sudo apt -y install borgbackup
                sudo pip3 install vorta
                ;;
            29)
                printf "${YELLOW}Installing spotify and spicetify...\n${NC}"
                cd ~
                curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
                echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
                sudo apt-get update && sudo apt-get -y install spotify-client
                # https://community.spotify.com/t5/Desktop-Linux/The-app-crashes-on-Debian-due-to-HW-acceleration/td-p/5049188
                # https://codereview.chromium.org/2384163002
                spotify --no-zygote && sleep 3 && killall spotify
                curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
                curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Please restart shell and launch command to apply spicetify: \n\n"
                printf "spicetify backup apply\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                ;;
        esac
    done
else
        exit 0
fi
