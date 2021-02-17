#!/usr/bin/env bash
  
base_directory="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" > /dev/null 2>&1 && pwd)"

mkdir -p ${HOME}/Library/Application\ Support/Code/User/ 
rm -f ${HOME}/Library/Application\ Support/Code/User/settings.json
ln -sf ${base_directory}/vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
