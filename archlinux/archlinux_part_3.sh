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

PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
source "$PATH_SCRIPT/main.sh"

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
	pacman -S --noconfirm xorg i3 lxappearance nitrogen dmenu archlinux-wallpaper
	
	#Lock screen
	git clone https://aur.archlinux.org/ly
	cd ./ly/
	makepkg -si
	
	systemctl enable ly.service
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
	sudo pacman -S --noconfirm dhcpcd
	systemctl enable --now dhcpcd
}

##############################
#Calling the functions
##############################

install_software_essential
install_desktop_utils
install_desktop_enviroment
install_driver_audio
install_driver_bluetooth
install_driver_printer
install_driver_video
install_network_interface

display_message_warning "Script has been finished!"

#display_message_warning "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"