#!/bin/bash

CURRENT_USER=$(whoami)
echo "Current user: $CURRENT_USER"
    
echo "Updating system..."
sudo apt update
sudo apt upgrade

echo "Install some packages..."
sudo apt -y install bwm-ng screen neovim filezilla meld vlc git htop jq
sudo apt -y install apt-transport-https curl

update-alternatives --config editor
sudo apt -y remove nano ed
    
echo "Installing Brave..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser.list
sudo apt update    
sudo apt -y install brave-browser    

echo "Installing Remmina..."
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret

echo "Installing VSCodium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt -y install codium

echo "Add user to dialout..."
sudo usermod -a -G dialout $CURRENT_USER

sudo curl -fsSLo /usr/local/sbin/vscodium-json-updater.sh https://raw.githubusercontent.com/AlessandroPerazzetta/vscodium-json-updater/main/update.sh
sudo chmod +x /usr/local/sbin/vscodium-json-updater.sh
sudo /usr/local/sbin/vscodium-json-updater.sh
    
echo "Installing Nemo action for VSCodium..."
sudo wget https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action -O ~/.local/share/nemo/actions/codium.nemo_action

echo "Installing DBeaver..."
sudo curl -fsSLo /tmp/dbeaver-ce_latest_amd64.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i /tmp/dbeaver-ce_latest_amd64.deb

echo "Installing SmartGit..."
sudo curl -fsSLo /tmp/smartgit-20_2_5.deb https://www.syntevo.com/downloads/smartgit/smartgit-20_2_5.deb
sudo dpkg -i /tmp/smartgit-20_2_5.deb

echo "Installing KeePassXC..."
sudo add-apt-repository ppa:phoerious/keepassxc
sudo apt update
sudo apt -y install keepassxc

echo "Installing QOwnNotes..."
sudo add-apt-repository ppa:pbek/qownnotes
sudo apt update
sudo apt -y install qownnotes

echo "Installing VirtualBox..."
sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt -y install virtualbox

echo "--------------------------------------------------------------------------------"
echo "Please download VirtualBox Oracle VM VirtualBox Extension Pack from here: "
echo "https://www.virtualbox.org/wiki/Downloads"
echo "and install manually from VirtualBox under File > Preferences > Extensions"
echo "--------------------------------------------------------------------------------"
read -n 1 -s -r -p "Press any key to continue"

echo "Installing Neovim resources..."
mkdir -p ~/.config/nvim/
curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim

cat > ~/.bash_aliases<< EOF
alias l='ls -lah'
alias cls='clear'
EOF
