#!/usr/bin/env sh

#/etc/locale.gen
#FILENAME="/home/henrikbeck95/Desktop/testing/locale.gen"
#FILENAME_BAK="/home/henrikbeck95/Desktop/testing/locale.bak"

#if [[ -f $FILENAME_BAK ]]; then
#    rm -f $FILENAME_BAK
#fi

#cp $FILENAME $FILENAME_BAK

#Uncomment the line: # pt_BR.UTF-8 UTF-8
#TEXT_OLD="# pt_BR.UTF-8 UTF-8"
#TEXT_NEW="pt_BR.UTF-8 UTF-8"
#sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME_BAK

##############################
#Functions
##############################

install_software_essential(){
	sudo timedatectl set-ntp true
	sudo hwclock --systohc

	sudo reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Sy

	sudo firewall-cmd --add-port=1025-65535/tcp --permanent
	sudo firewall-cmd --add-port=1025-65535/udp --permanent
	sudo firewall-cmd --reload
}

install_desktop_utils(){
	pacman -S --noconfirm xdg-user-dirs xdg-utils
}

install_desktop_enviroment_gnome(){
	sudo pacman -S --noconfirm xorg gdm gnome gnome-extra gnome-tweaks
	sudo systemctl enable gdm
}

install_desktop_enviroment_i3(){
	pacman -S --noconfirm xorg i3 lxappearance nitrogen dmenu
}

install_desktop_enviroment_kde(){
	sudo pacman -S --noconfirm xorg sddm plasma materia-kde
	#sudo pacman -S --noconfirm kde-applications
	sudo systemctl enable sddm
}

install_desktop_enviroment_xfce(){
	sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies
	sudo systemctl enable lightdm
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
	pacman -S --noconfirm 
	
	#X Window System QXL driver including Xspice server for virtual machine
	pacman -S --noconfirm  xf86-video-qxl

	#Select the option according to your graphic video manufacturer.
	lspci | grep -e VGA -e 3D
	
	#For Intel graphic video
	pacman -S xf86-video-intel
        
    #For AMD graphic video
	pacman -S xf86-video-amdgpu

    #For Nvidia graphic video
    pacman -S nvidia nvidia-utils nvidia-settings
}

install_softwares_useful(){
	pacman -S --noconfirm alacritty flatpak nautilus rsync
	#timeshift
	#paru
	#firefox
	#kdenlive simplescreenrecorder obs-studio vlc
}

install_softwares_theme(){
	pacman -S --noconfirm arc-gtk-theme arc-icon-theme papirus-icon-theme
}

install_softwares_fonts(){
	pacman -S --noconfirm dina-font tamsyn-font bdf-unifont ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font ttf-junicode adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji terminus-font
}

##############################
#Calling the functions
##############################

install_software_essential
install_desktop_utils
install_desktop_enviroment_gnome
#install_desktop_enviroment_kde
#install_desktop_enviroment_xfce
install_driver_audio
install_driver_bluetooth
install_driver_printer
install_driver_video
#install_softwares_useful
#install_softwares_theme
#install_softwares_fonts

##############################
#Organizing
##############################

install_softwares_qemu(){
	#https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/
	
	pacman -S --noconfirm 
	
	systemctl enable libvirtd
	usermod -aG libvirt henrikbeck95
}


install_terminal(){
	pacman -S --noconfirm bash-completion

	#https://ohmyposh.dev/docs/linux
}

#pacman -S avahi ntfs-3g gvfs gvfs-smb nfs-utils inetutils dnsutils hplip acpi acpi_call acpid tlp ipset firewalld sof-firmware nss-mdns

#systemctl enable avahi-daemon
#systemctl enable tlp # Improve battery life. You can comment this command out if you didn't install tlp, see above
#systemctl enable reflector.timer
#systemctl enable fstrim.timer
#systemctl enable firewalld
#systemctl enable acpid

#echo "ermanno ALL=(ALL) ALL" >> /etc/sudoers.d/ermanno
printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
