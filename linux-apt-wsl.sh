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
source ~/.zshrc
fnm install 20
fnm use 20

print "Installing nodejs packages..."
npm i -g pnpm yarn

# install bun
print "Installing bun..."
curl -fsSL https://bun.sh/install | bash

# Add repo apt
# install apt packages
print "Installing zsh..."
sudo apt install zsh -y

# Brew packages
print "install Brew packages"
# install php composer
brew install composer

# install ohmyzsh
# print "Installing ohmyzsh..."
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y