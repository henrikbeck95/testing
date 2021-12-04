#!/usr/bin/env sh

PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
source "$PATH_SCRIPT/main.sh"

##############################
#Functions
##############################

install_softwares_binary(){
	#LF file manager
	cd /tmp/
	wget -c https://github.com/gokcehan/lf/releases/download/r26/lf-linux-amd64.tar.gz
	tar -xf /tmp/lf-linux-amd64.tar.gz
	sudo mv /tmp/lf /usr/local/bin/lf

	#Install Oh-My-Posh with all themes
	sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
	sudo chmod +x /usr/local/bin/oh-my-posh
	mkdir ~/.poshthemes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
	unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
	chmod u+rw ~/.poshthemes/*.json
	rm ~/.poshthemes/themes.zip
}

install_compilation(){
	#Paru
	mkdir $HOME/compilation
	cd $HOME/compilation/
	git clone https://aur.archlinux.org/paru.git
	cd $HOME/compilation/paru/
	makepkg -si
}

install_softwares_github(){
	#ASDF
	git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1
}

install_softwares_platform(){
	#Flatpak
	sudo pacman -S --noconfirm flatpak

	#QEMU
	#https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/
	#pacman -S --noconfirm
	#systemctl enable libvirtd
	#usermod -aG libvirt henrikbeck95
}

install_softwares_pacman(){
	sudo pacman -S --noconfirm \
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
	sudo pacman -U $HOME/compilation/timeshift-21.09.1-3-x86_64.pkg.tar.zst

	#Libinput
	wget -c https://mirror.clarkson.edu/manjaro/testing/community/x86_64/libinput-gestures-2.69-1-any.pkg.tar.zst
	sudo pacman -U $HOME/compilation/libinput-gestures-2.69-1-any.pkg.tar.zst
	
	#Gestures
	wget -c https://mirror.clarkson.edu/manjaro/stable/community/x86_64/gestures-0.2.5-1-any.pkg.tar.zst
	sudo pacman -U $HOME/compilation/gestures-0.2.5-1-any.pkg.tar.zst
}

install_softwares_paru(){
	paru -S \
		timeshift
}

install_shell_zsh(){
	#Install ZSH shell
    sudo pacman -S --noconfirm \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions

	#Set ZSH as default shell
	echo -e $SHELL
	cat /etc/shells
	sudo chsh -s /usr/bin/zsh
	display_message_warning "Restart current session"
}

backup_timeshift(){
	#Change Timeshift engine
	sudo timeshift --btrfs

	#Linux all snapshots
	sudo timeshift --list

	#Create a snapshot
	sudo timeshift --create --comments "After install ArchLinux" --tags D
}

##############################
#Calling the functions
##############################

install_softwares_binary
install_compilation
install_softwares_github
install_softwares_platform
install_softwares_pacman
install_softwares_pacman_extra
install_softwares_pacman_manually
install_softwares_paru
install_shell_zsh
backup_timeshift

display_message_warning "Script has been finished!"