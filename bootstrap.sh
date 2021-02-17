#!/usr/bin/env bash

ask_for_sudo() {
  echo "The bootstrap script requires sudo permission..."
  sudo -v &> /dev/null

  # Update existing `sudo` time stamp
  # until this script has finished.
  #
  # https://gist.github.com/cowboy/3118588

  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  echo -e "\033[32mPassword cached\033[0m"
}

install_homebrew() {
  if ! command -v brew > /dev/null 2>&1; then
    echo "Installing Homebrew..."
    yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

ensure_bash_version() {
  if [[ $BASH_VERSINFO[0] < 5 ]]; then
    echo "Installing latest Bash version..."
    yes | brew install bash

    echo "We need to add the latest version of Bash to the available shells"
    echo "This requires sudo permissions. If you prefer, you can exit this script and complete"
    echo "the required steps manually, before re-running this script"

    read -p "Press any key to continue..." -n1 -s
    echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells

    echo "Changing the default shell for your user..."
    sudo chsh -s $(brew --prefix)/bin/bash $(whoami)

    echo "The default shell for your user has been updated to $(brew --prefix)/bin/bash (version: $($(brew --prefix)/bin/bash --version))"
    echo -e "\033[33mBefore you can continue, you will need to start a new shell session and re-run this script\033[0m"
    exit 0
  fi
}

source_scripts() {
  local script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)/scripts"

  for script in ${script_directory}/0*.sh; do
    source ${script}
  done
  unset script

  for script in ${script_directory}/1*.sh; do
    source ${script}
  done
  unset script
}

main() {
  ask_for_sudo
  install_homebrew
  ensure_bash_version
  source_scripts
}

# run the main function
main
