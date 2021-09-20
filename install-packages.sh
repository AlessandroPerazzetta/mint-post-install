#!/bin/bash
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

CURRENT_USER=$(whoami)
printf "${YELLOW}Current user: ${LGRAY}$CURRENT_USER\n${NC}"
  
printf "${YELLOW}Updating system...\n${NC}"
sudo apt update
sudo apt upgrade

printf "${YELLOW}Install some packages...\n${NC}"
sudo apt -y install bwm-ng screen neovim filezilla meld vlc git htop jq python3-serial
sudo apt -y install apt-transport-https curl

printf "${YELLOW}Set default editor...\n${NC}"
update-alternatives --config editor

printf "${YELLOW}Remove others editor...\n${NC}"
sudo apt -y remove nano ed

printf "${YELLOW}Set and install python3 as default python...\n${NC}"
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

printf "${YELLOW}Installing Brave...\n${NC}"
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
sudo apt update    
sudo apt -y install brave-browser    

printf "${YELLOW}Installing Remmina...\n${NC}"
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret

printf "${YELLOW}Installing VSCodium...\n${NC}"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt -y install codium

printf "${YELLOW}Installing VSCodium Extension Gallery updater...\n${NC}"
sudo curl -fsSLo /usr/local/sbin/vscodium-json-updater.sh https://raw.githubusercontent.com/AlessandroPerazzetta/vscodium-json-updater/main/update.sh
sudo chmod +x /usr/local/sbin/vscodium-json-updater.sh
sudo /usr/local/sbin/vscodium-json-updater.sh

printf "${YELLOW}Add user to dialout...\n${NC}"
sudo usermod -a -G dialout $CURRENT_USER
    
printf "${YELLOW}Installing Nemo action for VSCodium...\n${NC}"
sudo wget https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action -O ~/.local/share/nemo/actions/codium.nemo_action

printf "${YELLOW}Installing DBeaver...\n${NC}"
sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb

printf "${YELLOW}Installing SmartGit...\n${NC}"
sudo curl -fsSLo /tmp/smartgit-21_1_1.deb https://www.syntevo.com/downloads/smartgit/smartgit-21_1_1.deb
sudo dpkg -i /tmp/smartgit-21_1_1.deb

printf "${YELLOW}Installing KeePassXC...\n${NC}"
sudo add-apt-repository ppa:phoerious/keepassxc
sudo apt update
sudo apt -y install keepassxc

printf "${YELLOW}Installing QOwnNotes...\n${NC}"
sudo add-apt-repository ppa:pbek/qownnotes
sudo apt update
sudo apt -y install qownnotes

printf "${YELLOW}Installing VirtualBox...\n${NC}"
sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt -y install virtualbox

printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
printf "Please download VirtualBox Oracle VM VirtualBox Extension Pack from here: \n"
printf "https://www.virtualbox.org/wiki/Downloads\n"
printf "and install manually from VirtualBox under File > Preferences > Extensions\n"
printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
read -n 1 -s -r -p "Press any key to continue"
printf "\n${NC}"

printf "${YELLOW}Installing Telegram...\n${NC}"
curl -fsSLo /tmp/Telegram.xz https://telegram.org/dl/desktop/linux
sudo tar -xf Telegram.xz -C /opt/

printf "${YELLOW}Installing KiCad...\n${NC}"
sudo add-apt-repository --yes ppa:kicad/kicad-5.1-releases
sudo apt update
sudo apt -y install --install-recommends kicad

printf "${YELLOW}Installing Rust...\n${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

printf "${YELLOW}Installing Neovim resources...\n${NC}"
mkdir -p ~/.config/nvim/
curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim

printf "${YELLOW}Installing Xed resources...\n${NC}"
mkdir -p ~/.local/share/xed/styles/
curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml

printf "${YELLOW}Installing VLC Media Library...\n${NC}"
mkdir -p ~/.local/share/vlc/
curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf

cat > ~/.bash_aliases<< EOF
alias l='ls -lah'
alias cls='clear'
EOF
