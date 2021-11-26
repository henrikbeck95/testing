## Script

```bash
#!/usr/bin/env sh

#RPM Fusion
sudo dnf update
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update

#Codecs - Firefox
sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264

#VirtualBox shared folder
sudo adduser henrikbeck95 vboxsf
#sudo usermod -aG vboxsf henrikbeck95
#sudo chown -R henrikbeck95:henrikbeck95 /home/henrikbeck95/shared/

#AppImages
wget https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox/firefox-93.0.r20210927210923-x86_64.AppImage

#Flatpak setup
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.visualstudio.code

#RPM packages
sudo dnf install \
	gnome-tweaks \
	neofetch \
	vim
```

## Softwares

1. [x] Gnome Tweaks
1. [x] lf
1. [x] libreoffice
1. [x] Neofetch
1. [x] Vim
1. [x] Visual Studio Code

## Customization

1. [ ] Apply hot corner
1. [ ] Dracula theme for Gnome
1. [x] Create Dracula wallpaper with RedHat logo
1. [ ] Apply Dracula wallpaper with RedHat logo

## Data

- [x] Connect Firefox account
- [ ] Migrate from Microsoft bookmarks to Firefox
