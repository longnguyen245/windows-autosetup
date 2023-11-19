#!/bin/bash

# variables
YELLOW=$'\e[0;33m'
GREEN=$'\e[0;32m'
NC=$'\e[0m'

# functions
function print () {
    arg1=$1
    echo "${GREEN}${arg1}${NC}"
}

# update package list
print "Apt updating"
sudo apt update
# Upgrade
print "Upgrade..."
sudo apt upgrade -y

# install Homebrew
print "Installing HomeBrew..."
sudo -u $(whoami) -S /bin/bash -c 'curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh' | bash

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.zshrc
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

sudo apt-get install build-essential unzip curl -y
brew install gcc

# install nodejs
print "Installing nodejs..."
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.bashrc
fnm install 20
fnm use 20

print "Installing nodejs packages..."
npm i -g pnpm yarn

# install bun
print "Installing bun..."
curl -fsSL https://bun.sh/install | bash

# Add repo apt
print "Add repoes apt..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt install curl software-properties-common apt-transport-https ca-certificates -y
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg > /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update

# install apt packages
print "Installing zsh dolphin telegram-desktop google-chrome-stable code code-insiders..."
sudo apt install zsh dolphin telegram-desktop google-chrome-stable code code-insiders -y

print "Installing postman..."
if test -f ./linux_64 || test -f ./linux_64.tar.gz
then
{
    echo "Downloaded postman..."
}
else  
{
    echo "Downloading postman..."
    wget https://dl.pstmn.io/download/latest/linux_64
}
fi

if test -f ./linux_64
then 
{
    echo "Move postman..."
    mv ./linux_64 ~/Desktop/linux_64.tar.gz
}
fi

if ! test -d ~/Desktop/Postman ;then 
{
    echo "Extract postman..."
    tar -xvzf ~/Desktop/linux_64.tar.gz
}
fi

if ! test -d ~/apps ;then
    mkdir ~/apps
fi

if test -d ~/Desktop/Postman ;then
    if ! test -d ~/apps/Postman ;then  
        mv -f ~/Desktop/Postman ~/apps/Postman
    fi
fi

touch ~/.local/share/applications/Postman.desktop
echo "[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=~/apps/Postman/app/Postman %U
Icon=~/apps/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" > ~/.local/share/applications/Postman.desktop

# Brew packages
print "install Brew packages"
# install php composer
brew install composer

# install Ibus-bamboo
print "Installing Ibus-bamboo..."
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install ibus ibus-bamboo --install-recommends -y
ibus restart
# Đặt ibus-bamboo làm bộ gõ mặc định
env DCONF_PROFILE=ibus dconf write /desktop/ibus/general/preload-engines "['BambooUs', 'Bamboo']" && gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo')]"

# install ohmyzsh
print "Installing ohmyzsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y