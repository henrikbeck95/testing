#!/usr/bin/env sh

PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
source "$PATH_SCRIPT/main.sh"

##############################
#Functions
##############################

install_desktop_utils(){
	pacman -S --noconfirm xdg-user-dirs xdg-utils
}

install_desktop_enviroment_gnome(){
	pacman -S --noconfirm xorg gdm gnome gnome-extra gnome-tweaks
	systemctl enable gdm
}

install_desktop_enviroment_i3(){
	pacman -S --noconfirm xorg i3 lxappearance nitrogen dmenu archlinux-wallpaper
	
	#Lock screen
	git clone https://aur.archlinux.org/ly
	cd ./ly/
	makepkg -si
	
	systemctl enable ly.service
}

install_desktop_enviroment_kde(){
	pacman -S --noconfirm xorg sddm plasma materia-kde
	#pacman -S --noconfirm kde-applications
	systemctl enable sddm
}

install_desktop_enviroment_xfce(){
	pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies
	systemctl enable lightdm
}

install_desktop_enviroment(){
	display_message "Install desktop environment"

	while true; do
		read -p "Inform you want: [gnome/i3/kde/xfce/none] " QUESTION_DESKTOP_ENVIRONMENT

		case $QUESTION_DESKTOP_ENVIRONMENT in
			"gnome")
				install_desktop_enviroment_gnome
				break
				;;
			"i3")
				install_desktop_enviroment_i3
				break
				;;
			"kde")
				install_desktop_enviroment_kde
				break
				;;
			"xfce")
				install_desktop_enviroment_xfce
				break
				;;
			"none") break ;;
			*) echo "Please answer question." ;;
		esac
	done
}

install_driver_audio(){
	pacman -S --noconfirm alsa-utils pavucontrol
	#pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack
	pacman -S --noconfirm pulseaudio	
}

install_driver_bluetooth(){
	pacman -S --noconfirm bluez bluez-utils
	systemctl enable bluetooth
}

install_driver_printer(){
	pacman -S --noconfirm cups
	systemctl enable cups.service
}

install_driver_video(){
	display_message "Install video driver"

	#VirtualBox virtual machine video driver
	pacman -S --noconfirm virtualbox-guest-utils

	#VMWare virtual machine video driver
	pacman -S --noconfirm xf86-video-vmware

	#X Window System QXL driver including Xspice server for virtual machine
	pacman -S --noconfirm  xf86-video-qxl

	#Select the option according to your graphic video manufacturer.
	lspci | grep -e VGA -e 3D

	while true; do
		read -p "Inform you want: [amd/intel/nvidia/none] " QUESTION_SWAP

		case $QUESTION_SWAP in
			"amd")
				#For AMD graphic video
				pacman -S xf86-video-amdgpu
				break
				;;
			"intel")
				#For Intel graphic video
				pacman -S xf86-video-intel
				break
				;;
			"nvidia")
				#For Nvidia graphic video
				pacman -S nvidia nvidia-utils nvidia-settings
				break
				;;
			"none") break ;;
			*) echo "Please answer question." ;;
		esac
	done
}

install_network_interface(){
	pacman -S --noconfirm dhcpcd
	systemctl enable --now dhcpcd
}

install_software_essential(){
	timedatectl set-ntp true
	hwclock --systohc

	reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist
	pacman -Sy

	firewall-cmd --add-port=1025-65535/tcp --permanent
	firewall-cmd --add-port=1025-65535/udp --permanent
	firewall-cmd --reload
}

install_softwares_binary(){
	#LF file manager
	cd /tmp/
	wget -c https://github.com/gokcehan/lf/releases/download/r26/lf-linux-amd64.tar.gz
	tar -xf /tmp/lf-linux-amd64.tar.gz
	mv /tmp/lf /usr/local/bin/lf

	#Install Oh-My-Posh with all themes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
	chmod +x /usr/local/bin/oh-my-posh
	mkdir ~/.poshthemes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
	unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
	chmod u+rw ~/.poshthemes/*.json
	rm ~/.poshthemes/themes.zip
}

install_softwares_github(){
	#ASDF
	git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1
}

install_softwares_platform(){
	#Flatpak
	pacman -S --noconfirm flatpak

	#QEMU
	#https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/
	#pacman -S --noconfirm
	#systemctl enable libvirtd
	#usermod -aG libvirt henrikbeck95
}

install_softwares_pacman(){
	pacman -S --noconfirm \
        alacritty \
        ark \
        bash-completion \
        cheese \
        dolphin \
        ffmpeg \
        firejail \
        git \
        gparted \
        gthumb \
        htop \
        jq \
        linux-lts \
        lsb-release \
        neofetch \
        ntfs-3g \
        numlockx \
        okular \
        redshift \
		rsync \
        scrot \
        spectacle \
        tmux \
        unrar \
        unzip \
		vlc \
        wget

		#firefox kdenlive nautilus simplescreenrecorder obs-studio
}

install_softwares_pacman_extra(){
	pacman -S --noconfirm
		acpi \
		acpi_call \
		acpid \
		avahi \
		dnsutils \
		firewalld \
		gvfs \
		gvfs-smb \
		hplip \
		inetutils \
		ipset \
		nfs-utils \
		nss-mdns
		sof-firmware \
		tlp

	systemctl enable avahi-daemon
	systemctl enable acpid
	systemctl enable firewalld
	systemctl enable fstrim.timer
	systemctl enable reflector.timer
	systemctl enable tlp #Improve battery life for laptop.

	#echo "ermanno ALL=(ALL) ALL" >> /etc/sudoers.d/ermanno
}

install_softwares_pacman_manually(){
	mkdir $HOME/compilation/pacman/
	cd $HOME/compilation/pacman/

	#Timeshift
	wget -c https://mirror.clarkson.edu/manjaro/testing/community/x86_64/timeshift-21.09.1-3-x86_64.pkg.tar.zst
	pacman -U $HOME/compilation/timeshift-21.09.1-3-x86_64.pkg.tar.zst

	#Libinput
	wget -c https://mirror.clarkson.edu/manjaro/testing/community/x86_64/libinput-gestures-2.69-1-any.pkg.tar.zst
	pacman -U $HOME/compilation/libinput-gestures-2.69-1-any.pkg.tar.zst
	
	#Gestures
	wget -c https://mirror.clarkson.edu/manjaro/stable/community/x86_64/gestures-0.2.5-1-any.pkg.tar.zst
	pacman -U $HOME/compilation/gestures-0.2.5-1-any.pkg.tar.zst
}

install_shell_zsh(){
	#Install ZSH shell
    pacman -S --noconfirm \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions

	#Set ZSH as default shell
	echo -e $SHELL
	cat /etc/shells
	chsh -s /usr/bin/zsh
	display_message_warning "Restart current session"
}

backup_timeshift(){
	#Change Timeshift engine
	timeshift --btrfs

	#Linux all snapshots
	timeshift --list

	#Create a snapshot
	timeshift --create --comments "After install ArchLinux" --tags D
}

install_compilation(){
	#Paru
	mkdir $HOME/compilation
	cd $HOME/compilation/
	git clone https://aur.archlinux.org/paru.git
	cd $HOME/compilation/paru/
	makepkg -si
}

install_softwares_paru(){
	paru -S \
		timeshift
}

##############################
#Calling the functions
##############################

install_desktop_utils
install_desktop_enviroment
install_driver_audio
install_driver_bluetooth
install_driver_printer
install_driver_video
install_network_interface
install_software_essential
install_softwares_binary
install_softwares_github
install_softwares_platform
install_softwares_pacman
install_softwares_pacman_extra
install_softwares_pacman_manually
install_shell_zsh
backup_timeshift
#install_compilation
#install_softwares_paru

display_message_warning "Script has been finished!"

#display_message_warning "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"