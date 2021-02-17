#!/usr/bin/env bash
  
base_directory="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" > /dev/null 2>&1 && pwd)"

echo "Linking ${HOME}/.vimrc..."
ln -sf "${base_directory}/.vimrc" "${HOME}/.vimrc"

echo "Linking ${HOME}/.vim..."
ln -sf "${base_directory}/.vim/" "${HOME}/.vim"


