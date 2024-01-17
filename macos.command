#!/usr/bin/env bash

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install wget
brew install fnm

brew install --cask visual-studio-code
brew install --cask sourcetree
brew install --cask postman
brew install --cask skype
brew install --cask google-chrome
brew install --cask evkey
brew install --cask the-unarchiver


# Set enviroment
echo "Set enviroment"

cat << EOF >> ~/.bash_profile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

cat << EOF >> ~/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

cat << EOF >> ~/.bash_profile
# Add fnm env
eval "$(fnm env --use-on-cd)"
EOF

cat << EOF >> ~/.zprofile
# Add fnm env
eval "$(fnm env --use-on-cd)"
EOF

source ~/.bash_profile
source ~/.zprofile

# Install nodejs from fnm
echo "Install nodejs from fnm"
fnm env
fnm install 20
fnm use 20


# Clean up brew
echo "Cleaning up brew"
brew cleanup

# Done
echo "Done!"