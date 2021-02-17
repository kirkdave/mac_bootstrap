#!/usr/bin/env bash
  
if [[ -d /Volumes/Keybase/private/ ]]; then
  echo "Importing SSH key(s) and configuration from Keybase..."
  mkdir -p ${HOME}/.ssh
  for file in /Volumes/Keybase/private/*/ssh/*; do
    filename=${file##*/}
    if [ ! -f ${HOME}/.ssh/${filename} ]; then
      ln -sf ${file} ${HOME}/.ssh/${filename}
      chmod 700 ${HOME}/.ssh/${filename}
    fi
  done
else
  echo "Unable to find Keybase's private files. Have you enabled Keybase in Finder from Keybase settings?"
fi
