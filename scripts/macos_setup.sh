#!/usr/bin/env bash

# Quit if not MacOS
if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


echo ""
echo "Starting MacOS changes"
echo ""

# Ask for the administrator password upfront
echo "Enter sudo password:"
sudo -v
echo ""

# Keep-alive: update existing `sudo` time stamp 
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################

echo ""
echo "› General Tweaks:"

echo "  › Disable automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo "  › Enable text replacement almost everywhere"
defaults write -g WebAutomaticTextReplacementEnabled -bool true

echo "  › Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo "  › Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "  › Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "  › Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  › Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

echo "  › Remove the sleep image file to save disk space"
sudo rm /private/var/vm/sleepimage

echo "  › Create a zero-byte file instead…"
sudo touch /private/var/vm/sleepimage

echo "  › …and make sure it can’t be rewritten"
sudo chflags uchg /private/var/vm/sleepimage

echo "  › Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################

echo ""
echo "› TextEdit:"
echo "  › Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo "  › Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "  › Open a new file by default in TextEdit" 
defaults write -g NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

###############################################################################

echo ""
echo "› Trackpad/Keyboard:"

echo "  › Enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "  › Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10

###############################################################################

echo ""
echo "› Screen:"

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Save screenshots to ~/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

echo "  › Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "  › Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################

echo ""
echo "› Finder:"

echo "  › Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`

echo "  › Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  › Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "  › Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "  › When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "  › Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "  › Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "  › Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "  › Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo "  › Disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "  › Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  › Start in HOME directory"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo "  › Hide the 'Tags' section"
defaults write com.apple.finder ShowRecentTags -int 0

echo "  › Show the ~/Library folder"
chflags nohidden ~/Library

echo "  › Show the /Volumes folder"
sudo chflags nohidden /Volumes

###############################################################################

echo ""
echo "› Menu Bar:"

echo "  › Show the day of the week"
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

###############################################################################

echo ""
echo "› Dock:"

echo "  › Make hidden Apps be transparent in the dock"
defaults write com.apple.Dock showhidden -bool TRUE

echo "  › Configure Dock delay reveal"
defaults write com.apple.dock autohide-time-modifier -float 0.3

echo "  › Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo "  › Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "  › Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "  › Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

echo "  › Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "  › Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

###############################################################################

echo ""
echo "› Springboard:"

echo "  › Set number of columns"
defaults write com.apple.dock springboard-columns -int 12

echo "  › Set number of rows"
defaults write com.apple.dock springboard-rows -int 8

###############################################################################

echo ""
echo "› App Store:"

echo "  › Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "  › Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "  › Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "  › Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo "  › Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################

echo ""
echo "› Photos:"
echo "  › Disable it from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################

echo ""
echo "› Sound:"
echo "  › Disable the sound effects on boot"
sudo nvram SystemAudioVolume=0

###############################################################################

echo ""
echo "› Safari:"
echo "  › Set Safari’s home page to `about:blank` for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "  › Don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo ""
echo "MacOS changes finished."
echo ""
echo ""