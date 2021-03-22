#!/bin/bash
set -ex

# Ensure repositories are enabled
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo add-apt-repository restricted

# Add dell drivers for focal fossa
sudo sh -c 'cat > /etc/apt/sources.list.d/focal-dell.list << EOF
deb http://dell.archive.canonical.com/updates/ focal-dell public
# deb-src http://dell.archive.canonical.com/updates/ focal-dell public

deb http://dell.archive.canonical.com/updates/ focal-oem public
# deb-src http://dell.archive.canonical.com/updates/ focal-oem public

deb http://dell.archive.canonical.com/updates/ focal-somerville public
# deb-src http://dell.archive.canonical.com/updates/ focal-somerville public

deb http://dell.archive.canonical.com/updates/ focal-somerville-melisa public
# deb-src http://dell.archive.canonical.com/updates focal-somerville-melisa public
EOF'

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22

sudo apt update -qq

# Install general utilities
sudo apt install git flatpak vim vlc \ 
gnome-tweaks ubuntu-restricted-extras \
gnome-tweak-tool synaptic -y -qq

# Install drivers
sudo apt install oem-somerville-melisa-meta libfprint-2-tod1-goodix oem-somerville-meta tlp-config -y

# Install fusuma for handling gestures
sudo gpasswd -a $USER input
sudo apt install libinput-tools xdotool ruby -y -qq
sudo gem install --silent fusuma

# Install Howdy for facial recognition
sudo add-apt-repository ppa:boltgolt/howdy -y > /dev/null 2>&1
sudo apt update -qq
sudo apt install howdy -y;

# Remove packages:
sudo apt remove rhythmbox -y -q

# Add Flatpak support:
#sudo apt install gnome-software-plugin-flatpak -y
#sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Add Plata-theme
sudo add-apt-repository ppa:tista/plata-theme -y > /dev/null 2>&1
sudo apt update -qq && sudo apt install plata-theme -y

gsettings set org.gnome.desktop.interface gtk-theme "Plata-Noir-Compact"
gsettings set org.gnome.desktop.wm.preferences theme "Plata-Noir-Compact"

# Enable Shell Theme
sudo apt install gnome-shell-extensions -y
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell.extensions.user-theme name "Plata-Noir-Compact"

# Install fonts
sudo apt install fonts-firacode fonts-open-sans -y -qq

gsettings set org.gnome.desktop.interface font-name 'Open Sans 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 13'

## Add Java JDK LTS
sudo apt install openjdk-11-jdk -y

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt update -qq && sudo apt install code -y

## Post installation for code (sensible defaults)
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension eamodio.gitlens

sudo flatpak install postman -y

# Node Install
echo "Installing Node 14 JS LTS"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs 

# Setup GNOME material shell (Need node for compilation)
git clone https://github.com/PapyElGringo/material-shell.git ~/material-shell || true
make -C ~/material-shell/ install

## Chat
sudo flatpak install discord -y

## Multimedia
sudo flatpak install spotify -y

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# Brave
sudo apt install apt-transport-https curl gnupg
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# OBS Studio
sudo apt install ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio

# Flameshot
sudo apt install flameshot

# Gotta reboot now:
sudo apt update -qq && sudo apt upgrade -y && sudo apt autoremove -y

echo $'\n'$"Ready for REBOOT"
