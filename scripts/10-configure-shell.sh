#!/usr/bin/env bash

base_directory="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" > /dev/null 2>&1 && pwd)"

for file in ${base_directory}/shell/{.bashrc,.bash_profile,.inputrc}; do
  if [ ! -r "${HOME}/$(basename $file)" ]; then
    echo "Linking ${HOME}/$(basename $file)..."
    ln -sf "${file}" "${HOME}/$(basename $file)"
  fi
done
unset file
