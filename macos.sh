#!/usr/bin/env bash

base_directory="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" > /dev/null 2>&1 && pwd)"

# ===============================================
# Table of Contents
#
# 1.
# 2.
# 3.
# 4.
# 5.DOCK
# ===============================================


# ===============================================
# 5.DOCK
# ===============================================

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 24

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false


###############################################################################
# Kill affected applications

# "Activity Monitor"
# "Address Book"
# "Brave Browser"
# "Calendar"
# "cfprefsd"
# "Contacts"
# "Dock"
# "Finder"
# "Google Chrome"
# "Mail"
# "Messages"
# "Photos"
# "Safari"
# "SystemUIServer"
# "iCal"

for app in "Dock"; do
  killall "${app}" &> /dev/null
done
unset app

echo -e "\033[32mDone. Note that some of these changes require a logout/restart to take effect.\033[0m"