#!/usr/bin/env bash

BREWFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/../Brewfile"

if [ ! -d /Applications/1Password\ 7.app ]; then
  echo "Installing 1Password..."
  brew cask install 1password
  open /Applications/1Password\ 7.app
  read -n1 -p "1Password has been installed. Please login to 1Password and press any key to continue..."
fi

if [ ! -d /Applications/Keybase.app ]; then
  echo "Installing Keybase..."
  brew cask install keybase
  open /Applications/Keybase.app
  read -n1 -p "Keybase has been installed. Please login to Keybase then press any key to continue..."
fi

if [ ! -f /usr/local/opt/nvm/nvm.sh ]; then
  echo "Installing NVM..."
  brew install nvm
fi

if [ -f /usr/local/opt/nvm/nvm.sh ]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"
  echo "Install Node LTS via NVM..."
  nvm install --lts
  nvm install node # This is an alias for the latest version
else
  echo "Unable to find NVM so skipping Node installations..."
fi

if ! brew bundle --file=${BREWFILE}; then
  echo "Installing missing packages using Homebrew..."
  brew bundle install --file=${BREWFILE}
fi
