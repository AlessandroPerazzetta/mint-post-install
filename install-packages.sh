#!/bin/bash
echo "Updating system..."
sudo apt update && apt upgrade

echo "Install some packages..."
sudo apt install bwm-ng screen neovim filezilla meld vlc git htop jq
sudo apt install apt-transport-https curl

update-alternatives --config editor
sudo apt remove nano ed

echo "Installing Brave..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser

echo "Installing Remmina..."
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret

echo "Installing VSCodium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium

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

cat > ~/.bash_aliases<< EOF
alias l='ls -lah'
alias cls='clear'
EOF
