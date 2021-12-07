#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

DEBUG="false"
#DEBUG="true"

TERMINAL_COLOR_BLACK="\033[0;30m"
TERMINAL_COLOR_BLUE="\033[0;34m"
TERMINAL_COLOR_BLUE_LIGHT="\033[1;34m"
TERMINAL_COLOR_CYAN="\033[0;36m"
TERMINAL_COLOR_CYAN_LIGHT="\033[1;36m"
TERMINAL_COLOR_GRAY_DARK="\033[1;30m"
TERMINAL_COLOR_GRAY_LIGHT="\033[0;37m"
TERMINAL_COLOR_GREEN="\033[0;32m"
TERMINAL_COLOR_GREEN_LIGHT="\033[1;32m"
TERMINAL_COLOR_ORANGE="\033[0;33m"
TERMINAL_COLOR_PURPLE="\033[0;35m"
TERMINAL_COLOR_PURPLE_LIGHT="\033[1;35m"
TERMINAL_COLOR_RED="\033[0;31m"
TERMINAL_COLOR_RED_LIGHT="\033[1;31m"
TERMINAL_COLOR_WHITE="\033[1;37m"
TERMINAL_COLOR_YELLOW="\033[1;33m"
TERMINAL_COLOR_END="\033[0m"

TERMINAL_TEXT_BLINK="\e[5m" #\e[25m
TERMINAL_TEXT_BOLD="\e[1m"
TERMINAL_TEXT_BOLD_AND_ITALIC="\e[3m\e[1m"
TERMINAL_TEXT_ITALIC="\e[3m"
TERMINAL_TEXT_REVERSE="\e[7m" #\e[27m
TERMINAL_TEXT_STRIKETHROUGH="\e[9m"
TERMINAL_TEXT_UNDERLINE="\e[4m"
TERMINAL_TEXT_YYY="\e[31m"
TERMINAL_TEXT_ZZZ="\x1B[31m"
TERMINAL_TEXT_END="\e[0m"

TERMINAL_TEXT_BACKGROUND_WHITE_CYAN="\e[48:5:42m"
TERMINAL_TEXT_BACKGROUND_WHITE_ORANGE="\e[48:2::240:143:104m"
TERMINAL_TEXT_BACKGROUND_END="\e[49m"

LAYOUT_KEYBOARD="br-abnt2"

ARCHLINUX_SCRIPT_LINK="https://raw.githubusercontent.com/henrikbeck95/testing/main/archlinux.sh"

MESSAGE_HELP="
\t\t\t\tArchlinux installation setup
\t\t\t\t----------------------------

[Credits]
Author: Henrik Beck
E-mail: henrikbeck95@gmail.com
License: GPL3
Version: v.1.0.0

[Description]
This is a guided step by step for installing a custom ArchLinux with full setup

[Instructions]
Once you have booted your computer with a ArchLinux pendrive device, download this script by running:
$TERMINAL_COLOR_RED_LIGHT # curl -O -L $ARCHLINUX_SCRIPT_LINK $TERMINAL_COLOR_END

- Then give executable permission to this script and run it
$TERMINAL_COLOR_RED_LIGHT # chmod +x ./archlinux.sh && ./archlinux.sh -p1 $TERMINAL_COLOR_END

- When ArchLinux gets mounted as chroot, go to $TERMINAL_COLOR_RED_LIGHT /root/ directory $TERMINAL_COLOR_END download it again, give the executable permission and run it by using:
$TERMINAL_COLOR_RED_LIGHT # ./archlinux.sh -p2 $TERMINAL_COLOR_END

- When the second part from this script gets finished, type:
$TERMINAL_COLOR_RED_LIGHT # exit $TERMINAL_COLOR_END then $TERMINAL_COLOR_RED_LIGHT # umount -a poweroff $TERMINAL_COLOR_END

- Remove the pen drive device and boot the computer. Select the ArchLinux option on GRUB bootloader and log in as root. Finally run this script again by typing:
$TERMINAL_COLOR_RED_LIGHT # ./archlinux.sh -p3 $TERMINAL_COLOR_END

- If everything works correctly now you are up to ArchLinux normally. Furthermore if you want to install more softwares, log in as normal user and go head by typing:
$TERMINAL_COLOR_GREEN_LIGHT $ ./archlinux.sh -p4 $TERMINAL_COLOR_END then $TERMINAL_COLOR_GREEN_LIGHT $ systemctl reboot $TERMINAL_COLOR_END

- Finally:
$TERMINAL_COLOR_GREEN_LIGHT $ ./archlinux.sh -p5 $TERMINAL_COLOR_END then $TERMINAL_COLOR_GREEN_LIGHT $ systemctl reboot $TERMINAL_COLOR_END

- Enjoy it!

[Parameters]
-h\t--help\t-?\t\tDisplay this help message
-e\t--edit\t\t\tEdit this script file
-p1\t--part-01\t\tInstall ArchLinux system base $TERMINAL_COLOR_RED_LIGHT (ONLY ROOT) $TERMINAL_COLOR_END
-p2\t--part-02\t\tConfigure and install ArchLinux essential system softwares $TERMINAL_COLOR_RED_LIGHT (ONLY ROOT) $TERMINAL_COLOR_END
-p3\t--part-03\t\tInstall ArchLinux drivers, useful softwares and custom shell $TERMINAL_COLOR_RED_LIGHT (ONLY ROOT) $TERMINAL_COLOR_END
-p4\t--part-04\t\tInstall support platforms $TERMINAL_COLOR_RED_LIGHT (ONLY ROOT) $TERMINAL_COLOR_END
-p5\t--part-05\t\tInstall softwares to the final user
-t\t--testing\t\tTesting selected functions for debugging this script file
"

MESSAGE_RESTART="Must restart current session for apply the new settings"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions - Tools
#############################

check_if_internet_connection_exists(){
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "true"
    else
        echo "false"
    fi
}

check_if_user_has_root_previledges(){
	if [[ $UID != 0 ]]; then
		echo -e "You must be root for preduring this installation!"
		exit 0;
	fi
}

display_message(){
	echo -e "$TERMINAL_COLOR_WHITE \n#############################\n#$1\n#############################\n $TERMINAL_COLOR_END"
}

display_message_success(){
	echo -e "$TERMINAL_COLOR_GREEN_LIGHT \n#############################\n#$1\n#############################\n $TERMINAL_COLOR_END"
}

display_message_error(){
	echo -e "$TERMINAL_COLOR_RED_LIGHT \n#############################\n#Error! $1\n#############################\n $TERMINAL_COLOR_END"
}

display_message_warning(){
	echo -e "$TERMINAL_COLOR_YELLOW \n***$1*** $TERMINAL_COLOR_END"
}

tools_backup_create(){
    display_message "Creating Timeshift backup"

	#Change Timeshift engine
	timeshift --btrfs

	#Linux all snapshots
	timeshift --list

	#Create a snapshot
	timeshift --create --comments "$1" --tags D
}

tools_create_folder(){
	mkdir -p $1
}

tools_download_file(){
    display_message "Download $1 file"

	#cURL
	case $# in
		1) curl -L -O $1 ;;
		2) 
			cd $2
			pwd
			curl -L -O $1
			cd -
			;;
		*) display_message_error "Invalid option" ;;
	esac

	#Wget
	# case $# in
	# 	1) wget -c $1 ;;
	# 	2) wget -c $1 -O $2
	# 	*) display_message_error "Invalid option" ;;
	# esac
}

tools_edit_file(){
	#nano $@
	#vi -O $@
	vim -O $@
}

#TESTING
tools_install_software_aur(){
	case $DEBUG in
		"false") 
			paru -S $@ --noconfirm
			#paru -S $@ --noconfirm --needed

			#yay -S $@ --noconfirm
			#yay -S $@ --noconfirm --needed
		"true") 
			paru -S $@
			#paru -S $@ --needed

			#yay -S $@
			#yay -S $@ --needed
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

#TESTING
tools_install_software_flatpak(){
	case $DEBUG in
		"false") flatpak install flathub $@ -y
		"true") flatpak install flathub $@
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

#TESTING
tools_install_software_pacman(){
	case $DEBUG in
		"false") 
			pacman -S $@ --noconfirm
			#pacman -S $@ --noconfirm --needed 
		"true") 
			pacman -S $@
			#pacman -S $@ --needed
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

#TESTING
#MUST BE FIXED
tools_install_software_pip(){
	case $DEBUG in
		"false") pip3 install $@
		"true") pip3 install $@
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

#TESTING
tools_repositories_syncronize_aur(){
	display_message "Apply the new ArchLinux settings and check for updates"

	case $DEBUG in
		"false") 
			paru -Syyuu --noconfirm
			#yay -Syyuu --noconfirm
		"true") 
			paru -Syyuu
			#yay -Syyuu
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

#TESTING
tools_repositories_syncronize_pacman(){
	display_message "Apply the new ArchLinux settings and check for updates"

	case $DEBUG in
		"false") 
			pacman -Syyuu --noconfirm
		"true") 
			pacman -Syyuu
		*) display_message_error "$MESSAGE_ERROR" ;;
	esac
}

variables_export_bios(){
	PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
	ARCHLINUX_SCRIPT_PATH="$PATH_SCRIPT/"
	#ARCHLINUX_SCRIPT_PATH="$HOME/"
	#ARCHLINUX_SCRIPT_PATH="/root/"

	BIOS=$(ls -A /sys/firmware/efi/efivars 2>&1 /dev/null) #Verifying if BIOS supports UEFI

	#Verifying if BIOS supports UEFI by checking if directory is empty
	if [ -z "$(ls -A /sys/firmware/efi/efivars)" ]; then
		IS_BIOS_UEFI="legacy" #echo "Empty"
	else
		IS_BIOS_UEFI="uefi" #"Not Empty"
	fi

	display_message_warning "Your device BIOS is $IS_BIOS_UEFI"
}

variables_export_virtualization(){
	IS_VIRTUALIATION=$(hostnamectl | grep "Virtualization" | awk '{print $2}')

	if [[ $IS_VIRTUALIATION == "kvm" ]]; then
		display_message_warning "I know you are using a virtual machine!"

		PARTITION_PATH="/dev/vda"
		PARTITION_BOOT="/dev/vda1"
		PARTITION_ROOT="/dev/vda2"
		PARTITION_FILE="/dev/vda3"
		PARTITION_SWAP="/dev/vda4"

	else
		display_message_warning "Great! You are installing on your host machine!"

		PARTITION_PATH="/dev/sda"
		PARTITION_BOOT="/dev/sda1"
		PARTITION_ROOT="/dev/sda2"
		PARTITION_FILE="/dev/sda3"
		PARTITION_SWAP="/dev/sda4"
	fi
}

variables_export_processor(){
	PROCESSOR=$(cat /proc/cpuinfo | grep vendor_id | head -1 | awk '{print $3}')
	#PROCESSOR=$(cat /sys/devices/virtual/dmi/id/board_{vendor,name,version})

	display_message_warning "Your device processor family is $PROCESSOR"
}

#############################
#Functions - Normal
#############################

changing_hostname(){
	display_message "Change the hostname"

	#Applying the hostname to /etc/hostname file
	read -p "Inform the hostname you want: " QUESTION_HOST #biomachine
	echo "$QUESTION_HOST" > /etc/hostname #biomachine

	#Applying the hostname to /etc/hosts file
	echo -e "
	127.0.0.1\t\tlocalhost
	::1\t\t\tlocalhost
	127.0.0.1\t\t$QUESTION_HOST.localdomain\t\t$QUESTION_HOST" >> /etc/hosts

    display_message_success "Hostname has been successfully set as $QUESTION_HOST to /etc/hosts"
}

changing_language(){
	display_message "Change the language"

	#tools_edit_file /etc/locale.gen #Uncomment the pt_BR.UTF-8 UTF-8 line
	locale-gen
	
	echo LANG=en_US.UTF-8 >> /etc/locale.conf
	#echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

	echo KEYMAP=br-abnt2 >> /etc/vconsole.conf

    display_message_success "Language has been successfully set as LANG=en_US.UTF-8 to /etc/locale.conf and KEYMAP=br-abnt2 to /etc/vconsole.conf"
}

changing_language_keyboard(){
	display_message "Changing the keyboard layout settings"
	loadkeys $LAYOUT_KEYBOARD

    display_message_success "Loadkeys has been successfully as $LAYOUT_KEYBOARD"
}

changing_language_default(){
	display_message "Changing for Brazilian Portuguese keymap"

	#Uncomment the line: # pt_BR.UTF-8 UTF-8
	local FILENAME="/etc/locale.gen"

	TEXT_OLD="#pt_BR.UTF-8 UTF-8"
	TEXT_NEW="pt_BR.UTF-8 UTF-8"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

	#tools_edit_file $FILENAME
	
	#Apply the new settings
	export LANG=pt_BR.UTF-8

    display_message_success "Keymap has been successfully set as $TEXT_NEW to $FILENAME"
}

changing_password_root(){
	display_message "Change the root password"
	passwd
}

changing_timezone(){
	display_message "Search for UTC time zone"
	timedatectl list-timezones | grep Sao_Paulo
	
	display_message "Apply the UTC time zone"
	ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	
	display_message "Sync UTC clock with the hardware machine"
	hwclock --systohc --utc #UTC clock

	#timedatectl set-ntp true
	#hwclock --systohc #Hardware clock

    display_message_success "Timezone has been successfully set"
}

mount_chroot(){
	display_message "Log in as root on the ArchLinux which is going to be installed (not the installer iso one)"
	arch-chroot /mnt/
}

creating_fstab(){
	display_message "Generate the /etc/fstab file"
	genfstab -U /mnt >> /mnt/etc/fstab

    display_message_success "Fstab has been successfully generated"

	#Check if the /etc/fstab file was generated correctly
	cat /mnt/etc/fstab
}

creating_new_user(){
	display_message "Create a new user account to be ready to log in after the installation setup is done"

	read -p "Inform the username you want: " QUESTION_USERNAME #henrikbeck95
	useradd -mG wheel $QUESTION_USERNAME
	passwd $QUESTION_USERNAME

	#Add user to groups
	gpasswd -a $QUESTION_USERNAME audio
	gpasswd -a $QUESTION_USERNAME daemon
	gpasswd -a $QUESTION_USERNAME dbus
	gpasswd -a $QUESTION_USERNAME disk
	gpasswd -a $QUESTION_USERNAME games
	gpasswd -a $QUESTION_USERNAME lp
	gpasswd -a $QUESTION_USERNAME network
	gpasswd -a $QUESTION_USERNAME optical
	gpasswd -a $QUESTION_USERNAME power
	gpasswd -a $QUESTION_USERNAME rfkill
	gpasswd -a $QUESTION_USERNAME scanner
	gpasswd -a $QUESTION_USERNAME storage
	gpasswd -a $QUESTION_USERNAME users
	gpasswd -a $QUESTION_USERNAME video
}

connecting_internet_wifi(){
	display_message "Connect to Wi-Fi network"

	while true; do
		read -p "Inform what you want (when finish type skip): [iwctl/terminal/skip] " QUESTION_WIFI_METHOD

		case $QUESTION_WIFI_METHOD in
			"iwctl")
                display_message_warning "iwctl Wi-Fi connect\n\n> #device list\n> #station wlan0 scan\n> #station wlan0 get-networks\n> #station wlan0 connect <wireless network name>\n> #exit"

        	    iwctl
				;;
            "terminal")
                #Unblock driver
                rfkill list
                rfkill unblock wifi

                #Iwd commands
                #iwctl device list
                #iwctl station list
                iwtcl device wlan0 set-property Powered on
                iwctl station wlan0 scan
                iwctl station wlan0 get-networks

		        read -p "Inform the Wi-Fi network name you want to connect: " QUESTION_WIFI_NAME
                iwctl station wlan0 connect $QUESTION_WIFI_NAME
				;;
			"skip") break ;;
			*) echo "Please answer question." ;;
		esac

		#Testing the network connection
	    ping -c 3 archlinux.org
	done
}

#MUST BE IMPLEMENTED SED CUT FUNCTION
connecting_ssh(){
	display_message "Install OpenSSH software"
	pacman -Syy openssh
	systemctl enable --now sshd.service
	tools_edit_file /etc/ssh/sshd_config #Uncomment the port 22
    display_message_success "OpenSSH software has been installed"
	
	display_message "Change Root password"
	passwd root
	
	display_message "Get the ip address"
	ip addr
	
	display_message "Auxiliar machine\n	
	For rightly configuring the another PC with Linux, follow the steps below:
	
	$ sudo apt install openssh-client
	$ ssh -l <username> <ip_address>
	or $ ssh root@<ip_address>
	or $ ssh-keygen -f \"/home/your_user/.ssh/known_hosts\" -R \"192.168.1.221\""
}

database_software_reflector(){
    display_message "Sorting Pacman repository database to speed up downloading the packages"

	timedatectl set-ntp true
	hwclock --systohc

	reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist
	pacman -Sy

	firewall-cmd --add-port=1025-65535/tcp --permanent
	firewall-cmd --add-port=1025-65535/udp --permanent
	firewall-cmd --reload

    display_message_success "Pacman repository database has been sorted successfully"
}

editing_sudo_properties(){
	display_message "Setting the Vim as the default text editor and also edit the visudo file"

	#Uncomment the line: # %wheel ALL=(ALL) ALL
	local FILENAME="/etc/sudoers"

	TEXT_OLD="# %wheel ALL=(ALL) ALL"
	TEXT_NEW="%wheel ALL=(ALL) ALL"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

    display_message_success "Sudoers has been successfully set to allow all users to have sudo access"

	#EDITOR=vim visudo
	#echo "ermanno ALL=(ALL) ALL" >> /etc/sudoers.d/ermanno
	#echo "$QUESTION_USERNAME ALL=(ALL) ALL" >> /etc/sudoers.d/$QUESTION_USERNAME
}

#MUST BE IMPLEMENTED SED CUT FUNCTION - NOT WORKED
enabling_support_32_bits(){
	display_message "Enable 32 bits support"

	while true; do
		read -p "Do you want to enable 32 bits support? [Y/n] " QUESTION_PARTITION
		
        case $QUESTION_PARTITION in
			[Yy]*)
				#Uncomment the multilib and multilib-testing modules
				local FILENAME="/etc/pacman.conf"

				#############################
				#Multilib module
				#############################

				echo -e "Editing module_multilib..."
				TEXT_OLD="#\[multilib]"
				TEXT_OLD_LINE=$(cat $FILENAME_BACKUP | grep -n "$TEXT_OLD" | awk -F: '{print $1}')
				TEXT_OLD_LINE_AUX=$(($TEXT_OLD_LINE+1))

				#Replace the match line
				TEXT_NEW="[multilib]"
				sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME_BACKUP

				#Uncomment the match+1 line
				TEXT_NEW_AUX="Include = \/etc\/pacman.d\/mirrorlist"
				sed -i "$TEXT_OLD_LINE_AUX c\\$TEXT_NEW_AUX" $FILENAME_BACKUP

				#############################
				#Multilib-testing module
				#############################

				TEXT_OLD="#\[multilib-testing]"
				TEXT_OLD_LINE=$(cat $FILENAME_BACKUP | grep -n "$TEXT_OLD" | awk -F: '{print $1}')
				TEXT_OLD_LINE_AUX=$(($TEXT_OLD_LINE+1))

				#Replace the match line
				TEXT_NEW="[multilib-testing]"
				sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME_BACKUP

				#Uncomment the match+1 line
				TEXT_NEW_AUX="Include = \/etc\/pacman.d\/mirrorlist"
				sed -i "$TEXT_OLD_LINE_AUX c\\$TEXT_NEW_AUX" $FILENAME_BACKUP

				#############################
				#Verify if file has been created correctly
				#############################

				tools_edit_file $FILENAME
				break
				;;
			[Nn]*) break ;;
			*) echo "Please answer Y for yes or N for no." ;;
		esac
	done
}

#MUST BE FIXED
installing_bootloader(){
	display_message "Installing packages for the bootloader and the network tools"

	tools_install_software_pacman \
        grub \
		base-devel \
		cron \
		dialog \
		dosfstools \
		efibootmgr \
		linux-lts-headers \
		mtools \
		networkmanager \
		network-manager-applet \
		os-prober \
		reflector \
		wireless_tools \
		wpa_supplicant

	#Enable the NetworkManager 
	systemctl enable --now NetworkManager.service

	#Configuring GRUB by commenting the line: MODULES=()
	local FILENAME="/etc/mkinitcpio.conf"

	TEXT_OLD="MODULES=()"
	TEXT_NEW="MODULES=(btrfs)"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

	#vim $FILENAME #Add text: MODULES=(btrfs)
	mkinitcpio -p linux
	#mkinitcpio -p linux-lts

	#Applying GRUB
	case $IS_BIOS_UEFI in #MUST BE FIXED
		"legacy")
			#grub-install --target=x86_64-efi --bootloader-id=GRUB
			#grub-install --target=x86_64-efi --boot-directory=/boot/efi --bootloader-id=GRUB
			#efibootmgr -c -d /dev/sda -p 1 -L "ArchLinux" -l \vmlinuz-linux -u "root=/dev/sda2 rw initrd=/initramfs-linux.img"
			display_message_error "
			Sorry but I do not how to install GRUB on BIOS legacy machine
			If you know how, please inform the developer the procedure for implementing it.
			For now, the commands must be implemented manually
			Do not worry, this is the last step to be done."

			exit 0
			;;
		"uefi") 
			grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

			grub-mkconfig -o /boot/grub/grub.cfg

        	display_message_success "GRUB gootloader has been successfully installed"
			;;
		*)
			display_message_error "The BIOS could not be identified!"
			exit 0
			;;
	esac
}

install_driver_audio(){
	tools_install_software_pacman \
        alsa-utils \
        pavucontrol

	while true; do
		read -p "Inform what you want: [pipewire/pulseaudio/none] " QUESTION_SWAP

		case $QUESTION_SWAP in
			"pipewire")
                tools_install_software_pacman \
                    pipewire \
                    pipewire-alsa \
                    pipewire-pulse \
                    pipewire-jack
				
	                display_message_success "Pipeware has been successfully installed"
                break
				;;
			"pulseaudio")
            	tools_install_software_pacman \
                    pulseaudio

	                display_message_success "Pulseaudio has been successfully installed"
				break
				;;
			"none") break ;;
			*) echo "Please answer question." ;;
		esac
	done
}

install_driver_bluetooth(){
    display_message "Install bluetooth drivers"

	tools_install_software_pacman \
        bluez \
        bluez-utils

	systemctl enable --now bluetooth
    display_message_success "Bluetooth drivers have been successfully installed"
}

install_driver_printer(){
    display_message "Install printer drivers"

	tools_install_software_pacman \
        cups

	systemctl enable --now cups.service
    display_message_success "Printer drivers have been successfully installed"
}

install_driver_graphic_video(){
    display_message "Install video driver for VirtualBox, X Window System QXL (including Xspice server) and VMWare virtual machine video driver"
    
    tools_install_software_pacman \
        virtualbox-guest-utils \
        xf86-video-qxl \
        xf86-video-vmware

	while true; do
        #Select the option according to your graphic video manufacturer.
        lspci | grep -e VGA -e 3D

		read -p "Inform what you want: [amd/intel/nvidia/none] " QUESTION_SWAP

		case $QUESTION_SWAP in
			"amd")
				tools_install_software_pacman \
                    xf86-video-amdgpu

                display_message_success "Video driver has been successfully installed for AMD cards"
				break
				;;
			"intel")
				tools_install_software_pacman \
                    xf86-video-intel

                display_message_success "Video driver has been successfully installed for Intel cards"
				break
				;;
			"nvidia")
				tools_install_software_pacman \
                    nvidia \
                    nvidia-utils \
                    nvidia-settings

                display_message_success "Video driver has been successfully installed for Nvidia cards"
				break
				;;
			"none") break ;;
			*) echo "Please answer question." ;;
		esac
	done
}

install_desktop_enviroment_main(){
	display_message "Install desktop environment"

	while true; do
		read -p "Inform what you want: [deepin/gnome/i3/kde/xfce/none] " QUESTION_DESKTOP_ENVIRONMENT

		case $QUESTION_DESKTOP_ENVIRONMENT in
			"deepin")
				install_desktop_enviroment_deepin
				break
				;;
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

install_desktop_enviroment_deepin(){
    tools_install_software_pacman \
		xorg \
		deepin \
		deepin-extra \
		lightdm
		#xorg-server

	echo "greeter-session=lightdm-deepin-greeter" >> /etc/lightdm/lightdm.conf
	#echo "display-setup-script=xrandr --output virtual-1 --mode 1920x1080" >> /etc/lightdm/lightdm.conf

	systemctl enable lightdm.service

    display_message_success "Deepin as desktop environment has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_desktop_enviroment_gnome(){
	tools_install_software_pacman \
        xorg \
        gdm \
        gnome \
        gnome-extra \
        gnome-tweaks

	systemctl enable gdm

    display_message_success "Gnome as desktop environment has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_desktop_enviroment_i3(){
	tools_install_software_pacman \
        xorg \
        i3 \
        dmenu \
		feh \
        lxappearance \
        nitrogen \
		polybar \
		rofi
	
	install_lock_screen

    display_message_success "I3 as desktop environment has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_desktop_enviroment_kde(){
	tools_install_software_pacman \
        xorg \
        sddm \
        plasma \
        materia-kde
	    #kde-applications

	systemctl enable sddm

    display_message_success "KDE as desktop environment has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_desktop_enviroment_xfce(){
	tools_install_software_pacman \
        xorg \
        lightdm \
        lightdm-gtk-greeter \
        lightdm-gtk-greeter-settings \
        xfce4 \
        xfce4-goodies

	systemctl enable lightdm

    display_message_success "XFCE as desktop environment has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_desktop_utils(){
    display_message "Install desktop utils"

	tools_install_software_pacman \
        xdg-user-dirs \
        xdg-utils

    display_message_success "Desktop utils have been successfully installed"
}

install_lock_screen(){
	display_message "Install lock screen"

	while true; do
		read -p "Inform what you want: [lightdm/ly/none] " QUESTION_LOCK_SCREEN

		case $QUESTION_LOCK_SCREEN in
			"lightdm")
                gnome-disk-utility \
                lightdm \
                lightdm-gtk-greeter \
                lightdm-gtk-greeter-settings

                systemctl enable lightdm.service -f
                systemctl set-default graphical.target
                
	            display_message_success "LightDM has been installed as lock screen"
				break
				;;
            "ly")
                git clone https://aur.archlinux.org/ly
                cd ./ly/
                makepkg -si
                
                systemctl enable ly.service

	            display_message_success "Ly has been installed as lock screen"
				break
				;;
			"none") break ;;
			*) echo "Please answer question." ;;
		esac
	done

	display_message_warning "$MESSAGE_RESTART"
}

install_network_interface(){
    display_message "Install network insface"

	tools_install_software_pacman \
        dhcpcd

	systemctl enable --now dhcpcd

    display_message_success "Network interface has been successfully installed"
}

install_shell_zsh(){
    display_message "Install ZSH shell"
	
    #Install ZSH shell
    tools_install_software_pacman \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions

	#Set ZSH as default shell
	echo -e $SHELL
	cat /etc/shells
	chsh -s /usr/bin/zsh
    
    display_message_success "ZSH shell has been successfully installed"
	display_message_warning "$MESSAGE_RESTART"
}

install_softwares_aur(){
    display_message "Install softwares from ArchLinux User Repository(AUR)"

	tools_install_software_aur \
		barrier \
		cava \
		timeshift

		#android-studio \
		#cava \
		#davinci-resolve \
		#dropbox \
		#google-chrome \
		#ffmpeg-full \
		#flutter \
		#lf \
		#nerd-fonts-complete \
		#ntfs3-dkms \
		#nvm \
		#polybar \
		#proton \
		#qt5-styleplugins \
		#spotify-adblock \
		#spotirec \
		#ttf-ms-fonts

    display_message_success "Softwares from ArchLinux User Repository(AUR) have been installed"
}

#MUST BE IMPROVED
install_softwares_binary(){
	#LF file manager
    display_message "Install softwares from Binary - LF file manage"

	cd /tmp/
	tools_download_file https://github.com/gokcehan/lf/releases/download/r26/lf-linux-amd64.tar.gz
	tar -xf /tmp/lf-linux-amd64.tar.gz
	mv /tmp/lf /usr/local/bin/lf
	cd -

    display_message_success "LF file manager has been installed from binary"

	#Install Oh-My-Posh with all themes
    display_message "Install softwares from Binary - Oh-My-Posh!"

	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
	chmod +x /usr/local/bin/oh-my-posh
	tools_create_folder $HOME/.poshthemes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O $HOME/.poshthemes/themes.zip
	unzip $HOME/.poshthemes/themes.zip -d $HOME/.poshthemes
	chmod u+rw $HOME/.poshthemes/*.json
	rm $HOME/.poshthemes/themes.zip

    display_message_success "Oh-My-Posh! has been installed from binary"
}

install_softwares_compilation(){
	#Paru
    display_message "Install softwares from compiation - Paru"

	tools_create_folder $HOME/compilation/
	git clone https://aur.archlinux.org/paru.git $HOME/compilation/paru

	cd $HOME/compilation/paru/
	makepkg -si
	cd -

    display_message_success "Softwares from compilation has been installed - Paru"
}

install_softwares_github(){
	#ASDF
    display_message "Install softwares from GitHub - ASDF"

	git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1

    display_message_success "Softwares from GitHub has been installed - ASDF"
}

install_softwares_flatpak(){
    display_message "Install softwares from Flatpak"

    tools_install_software_flatpak \
        org.kde.ark \
        com.github.debauchee.barrier \
        com.usebottles.bottles \
        org.kde.dolphin \
        org.mozilla.firefox \
        org.gimp.GIMP \
        org.libreoffice.LibreOffice \
        com.github.phase1geo.minder \
        org.musicbrainz.Picard \
        org.nomacs.ImageLounge \
        com.obsproject.Studio \
        org.kde.okular \
        com.github.jeromerobert.pdfarranger \
        com.github.junrrein.PDFSlicer \
        com.github.alainm23.planner \
        com.spotify.Client \
        com.github.micahflee.torbrowser-launcher \
        com.transmissionbt.Transmission \
        com.visualstudio.code \
        org.videolan.VLC

        #org.audacityteam.Audacity \
        #org.openchemistry.Avogadro2 \
        #com.github.carlos157oliveira.Calculus \
        #com.calibre_ebook.calibre \
        #org.chromium.Chromium \
        #nl.hjdskes.gcolor3 \
        #org.gnome.design.Contrast \
        #org.darktable.Darktable \
        #org.gnome.DejaDup \
        #com.discordapp.Discord \
        #com.dropbox.Client \
        #com.github.maoschanz.drawing \
        #org.eclipse.Java \
        #io.github.Figma_Linux.figma_linux \
        #org.filezillaproject.Filezilla \
        #org.freecadweb.FreeCAD \
        #org.gnome.Geary \
        #org.gnome.Books \
        #org.gnome.Calendar \
        #org.gnome.Documents \
        #org.gnome.gitlab.YaLTeR.Identity \
        #org.gnome.Notes \
        #org.gnome.Photos \
        #org.octave.Octave \
        #io.designer.GravitDesigner \
        #fr.handbrake.ghb \
        #org.inkscape.Inkscape \
        #br.gov.cti.invesalius \
        #org.kde.kdenlive \
        #org.keepassxc.KeePassXC \
        #org.kde.krita \
        #com.microsoft.Teams \
        #io.mpv.Mpv \
        #com.musixmatch.Musixmatch \
        #com.getpostman.Postman \
        #io.github.Qalculate \
        #org.qutebrowser.qutebrowser \
        #org.remmina.Remmina \
        #net.rpcs3.RPCS3 \
        #com.stremio.Stremio \
        #com.sweethome3d.Sweethome3d \
        #com.unity.UnityHub \
        #com.vscodium.codium

    display_message_success "Softwares from Flatpak has been installed"
}

install_softwares_pacman_essential(){
    display_message "Install softwares from Pacman - essential"

	#Kernel
	tools_install_software_pacman \
		linux-lts

	#Useful
	tools_install_software_pacman \
        alacritty \
        ark \
        bash-completion \
        cheese \
        ffmpeg \
        firejail \
        git \
        gparted \
        htop \
        jq \
        lsb-release \
        neofetch \
        ntfs-3g \
        numlockx \
        redshift \
		rsync \
        scrot \
		subversion \
        tmux \
        unrar \
        unzip \
        wget

    	#arandr \
		#xorg-xrandr \

	#Laptop battery improvement
	tools_install_software_pacman \
		acpi \
		acpi_call \
		acpid \
		tlp

	#Others
	tools_install_software_pacman \
		avahi \
		dnsutils \
		firewalld \
		gvfs \
		gvfs-smb \
		inetutils \
		ipset \
		nfs-utils \
		nss-mdns \
		sof-firmware

		#gufw #Firewall
		#hplip #HP printer

	systemctl enable avahi-daemon
	systemctl enable acpid
	systemctl enable firewalld
	systemctl enable fstrim.timer
	systemctl enable reflector.timer
	systemctl enable tlp #Improve battery life for laptop.

    display_message_success "Softwares from Pacman has been installed - essential"
}

install_softwares_pacman_extra(){
    display_message "Install softwares from Pacman - extra"

	tools_install_software_pacman \
		dolphin \
		gthumb \
		lolcat \
		neofetch \
		nmap \
		okular \
		spectacle
        #archlinux-wallpaper \
		#cmatrix \
		#firefox \
		#go \
		#kdenlive \
		#nautilus \
		#obs-studio \
		#simplescreenrecorder \
		#vlc

    display_message_success "Softwares from Pacman has been installed - extra"
}

install_softwares_pacman_manually(){
    display_message "Install softwares from Pacman - manually"

	tools_create_folder $HOME/compilation/pacman/
	cd $HOME/compilation/pacman/

	#Timeshift
	tools_download_file https://mirror.clarkson.edu/manjaro/testing/community/x86_64/timeshift-21.09.1-3-x86_64.pkg.tar.zst
	pacman -U $HOME/compilation/timeshift-21.09.1-3-x86_64.pkg.tar.zst

	#Libinput
	tools_download_file https://mirror.clarkson.edu/manjaro/testing/community/x86_64/libinput-gestures-2.69-1-any.pkg.tar.zst
	pacman -U $HOME/compilation/libinput-gestures-2.69-1-any.pkg.tar.zst
	
	#Gestures
	tools_download_file https://mirror.clarkson.edu/manjaro/stable/community/x86_64/gestures-0.2.5-1-any.pkg.tar.zst
	pacman -U $HOME/compilation/gestures-0.2.5-1-any.pkg.tar.zst

	cd -

    display_message_success "Softwares from Pacman has been installed - manually"
}

install_softwares_pip(){
    display_message "Install softwares from Python - Pip"

    tools_install_software_pip \
    	lyrics-in-terminal \
    	safeeyes

    display_message_success "Softwares from Python has been installed - Pip"
}

install_support_debtap(){
    display_message "Install software platform Debtap"

    tools_install_software_aur \
		debtap

	debtap -u

    display_message_success "Deptap software platform has been installed"
}

#MUST BE TESTED
install_support_docker(){
    display_message "Install software platform Docker"

    #Installation
	tools_install_software_pacman \
		docker \
		docker-compose

    #Enabling
	systemctl enable --now docker

	#Checking version
    docker --version

    #Removing sudo requirement
	#getent group docker && sudo gpasswd -a $(whoami) docker && echo -e "\n***Log out and then login to apply the changes or restart the operating system***\n"

	display_message_warning "$MESSAGE_RESTART"

    #Verify that you can run docker commands without sudo
	#docker run hello-world

    display_message_success "Docker software platform has been installed"
}

install_support_flatpak(){
    display_message "Install software platform Flatpak"

	#Flatpak
	tools_install_software_pacman \
        flatpak

	display_message_warning "$MESSAGE_RESTART"

    display_message_success "Flatpak software platform has been installed"
}

install_support_pip(){
    display_message "Install software platform Python Pip"

    tools_install_software_pacman \
        python-pip

    display_message_success "Python Pip software platform has been installed"
}

#MUST BE FIXED
install_support_podman(){
    display_message "Install software platform Podman"

	tools_edit_file /etc/default/grub
	#Edit the line: GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet video=1920x1080 cgroup_no_v1 "all""

	grub-mkconfig -o /boot/grub/grub.cfg
	display_message_warning "$MESSAGE_RESTART"

	tools_install_software_pacman \
		buildah \
		crun \
		podman

		#cgroups

	#systemctl enable --now podman.service
	systemctl enable --now podman.socket

	##Check the value of the Podman previledges
	# case $(sysctl kernel.unprivileged_userns_clone) in
	# 	0) 
	# 	1) 
	# 	*) display_message_error "" ;;
	# esac

	#Rootless
	touch /etc/{subuid,subgid}

	read -p "Inform the username you want: " QUESTION_USERNAME #henrikbeck95
	usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $QUESTION_USERNAME
	grep $QUESTION_USERNAME /etc/subgid /etc/subuid
	
	#echo -e "$QUESTION_USERNAME:100000:65536" > /etc/subuid
	#echo -e "$QUESTION_USERNAME:100000:65536" > /etc/subgid

	#echo -e "buildah:100000:65536" >> /etc/subuid
	#echo -e "buildah:100000:65536" >> /etc/subgid
	
	#Check if everything is set up rightly
	tools_edit_file /etc/subgid /etc/subuid

	#Propagate changes to subuid and subgid
	podman system migrate

	#display_message_warning "$MESSAGE_RESTART"

	#sudo dnf install -y podman-docker
	#podman pull docker.io/centos

	##############################
	#Podman Ngnix example
	##############################
	#
	#man podman
	#podman search nginx
	#podman pull docker.io/library/nginx
	#podman images
	#podman run -dt 
	#sudo mkdir -p /web/
	#podman run -d -v /web/:/usr/share/nginx/html -p 8080:80/tcp nginx
	#podman ps
	#
	##############################
	#Create a webpage, access it passthrought the firewall
	##############################
	#
	#chown $QUESTION_USERNAME: /web/
	#echo -e "Hello world from the container" > /web/index.html
	#sudo firewall-cmd --add-port=8080/tcp
	#xgd-open http://localhost:8080
	#sudo firewall-cmd --add-port=8080/tcp --permanent
	#
	##############################
	#Create a systemd instance for persistenting the container after reboot
	##############################
	#
	#sudo loginctl enable-linger $QUESTION_USERNAME
	#loginctl user-status $QUESTION_USERNAME
	#mkdir -p $HOME/.config/systemd/user/
	#cd $HOME/.config/systemd/user/
	#podman generate systemd --name <container_name> --files
	#systemctl --user daemon-reload
	#systemctl --user enable <container_name>
	#display_message_warning "$MESSAGE_RESTART"
	#
	##############################
	#Disable a systemd instance
	##############################
	#
	#podman ps
	#systemctl --user status <container_name>
	#systemctl --user disable --now <container_name>
	#podman ps
	#podman ps -a
	#
	##############################

    display_message_success "Podman software platform has been installed"
}

#MUST BE FIXED
#MUST BE IMPROVED
install_support_qemu(){
    display_message "Install software platform QEMU"

	#Reference
	#[Arch Linux: Instalação do virt-manager](https://www.youtube.com/watch?v=FGeI4nSOHto)
	#[](https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/)
	#[](https://computingforgeeks.com/complete-installation-of-kvmqemu-and-virt-manager-on-arch-linux-and-manjaro/)

	#Check if virtualization procedure is available on current machine
	LC_ALL=C lscpu | grep Virtualization

	#Virt-Manager
    #The Ebtables is an internet brigde software

	tools_install_software_pacman \
		bridge-utils \
		dnsmasq \
		ebtables \
		libvirt \
		openbsd-netcat \
		qemu \
		virt-manager

		#iptables \
		#vde2 \
        #virt-viewer
	
	#tools_install_software_aur \
        #libguestfs

		echo -e 'unix_sock_group = "libvirt"' > /etc/libvirt/libvirtd.conf
		echo -e 'unix_sock_rw_perms = "0770"' > /etc/libvirt/libvirtd.conf
		#tools_edit_file /etc/libvirt/libvirtd.conf

    #Enabling Systemd process
	systemctl enable --now libvirtd.service
	systemctl enable --now dnsmasq.service

	#Add user to the following groups
	read -p "Inform the username you want: " QUESTION_USERNAME #henrikbeck95
	gpasswd -a $QUESTION_USERNAME libvirt
	#usermod -G libvirt -a $QUESTION_USERNAME
	#usermod -aG libvirt $QUESTION_USERNAME

	#Create a virtual machine
    #qemu-img convert -f vdi -O qcow2 Ubuntu\ 20.04.vdi /var/lib/libvirt/images/ubuntu-20-04.qcow2

	#virsh net-dumpxml default > br1.xml
	#vim br1.xml

	display_message_warning "$MESSAGE_RESTART"

	#Cockpit
	tools_install_software_pacman \
		cockpit \
		cockpit-machines \
		cockpit-pcp \
		cockpit-podman

    #Enabling Systemd process
	systemctl enable --now cockpit.socket

	#Access Cockpit localhost from browser
	#xdg-open https://localhost:9090/

    display_message_success "QEMU software platform has been installed"
}

install_support_snap(){
    display_message "Install software platform Snap"

    tools_install_software_pacman \
        snapd

    #Enabling the Snap core on systemd
    systemctl enable --now snapd.socket

	display_message_warning "$MESSAGE_RESTART"

    display_message_success "Snap software platform has been installed"
}

install_support_ssh(){
    display_message "Install software platform SSH"

	display_message "Installing SSH connect support"
		
	tools_install_software_pacman \
		openssh

	systemctl enable --now sshd.service

    display_message_success "SSH software platform has been installed"
}

install_support_wine(){
    display_message "Install software platform WINE"

	tools_install_software_pacman \
		wine \
		winetricks

    display_message_success "WINE software platform has been installed"
}

install_system_base(){
    display_message "Install ArchLinux system base"

	#Kernel
	#pacstrap /mnt/ \
		#linux-lts \

	#System base
	pacstrap /mnt/ \
		base \
		btrfs-progs \
		linux-firmware \
		vim

	case $PROCESSOR in
		"AuthenticAMD") pacstrap /mnt/ amd-ucode ;;
		"GenuineIntel") pacstrap /mnt/ intel-ucode ;;
		*)
			display_message_error "Your processor could not be identified!"
			exit 0
		;;
	esac

    display_message_success "ArchLinux system base has been installed"
}

partiting_disk(){
	display_message "Make the partitions"

	#Creating the partitions
	while true; do
		cfdisk $PARTITION_PATH

		read -p "Do you want to procedure? [Y/n] " QUESTION_PARTITION
		case $QUESTION_PARTITION in
			[Yy]*) break ;;
			[Nn]*) : ;;
			*) echo "Please answer Y for yes or N for no." ;;
		esac
	done
	
	#Formatting the partitions
	mkfs.fat -F32 $PARTITION_BOOT
	#mkfs.fat -F32 -n ESP $PARTITION_BOOT
	#mkfs.fat -F32 -n BOOT $PARTITION_BOOT
	mkfs.btrfs -f $PARTITION_ROOT
	mkfs.ext4 -f $PARTITION_FILE

	#Listing all the partition table
	lsblk

    display_message_success "Partitions have been formatted"
}

#MUST BE FIXED
partiting_mounting(){
	display_message "Mount the BTRFS partitions"

	#Mounting the root partition
	mount $PARTITION_ROOT /mnt/

	#Creating subvolumes for BTRFS
	btrfs su cr /mnt/@/

	#Mounting root subvolume
	umount /mnt/
	mount -o compress=lzo,subvol=@ $PARTITION_ROOT /mnt/
	
	#Listing all the partition table
	lsblk

	#Mounting boot
	case $IS_BIOS_UEFI in
		"legacy") 
			#MUST BE FIXED
			#mkdir -p /mnt/boot/
			#mount $PARTITION_BOOT /mnt/boot/

			display_message_error "
			Sorry but I do not how to install GRUB on BIOS legacy machine
			If you know how, please inform the developer the procedure for implementing it.
			For now, the commands must be implemented manually
			Do not worry, this is the last step to be done."

			exit 0
			;;
		"uefi") 
			mkdir -p /mnt/boot/efi/
			mount $PARTITION_BOOT /mnt/boot/efi/
			;;
		*)
			display_message_error "The BIOS could not be identified!"
			exit 0
			;;
	esac

	#Listing all the partition table
	lsblk

    display_message_success "BTRFS partitions have been mounted"
}

partiting_swap(){
	display_message "Create the SWAP"

	while true; do
		read -p "Inform what you want: [file/partition/none] " QUESTION_SWAP

		case $QUESTION_SWAP in
			"file")
				partiting_swap_file
				break
				;;
			"partition")
				partiting_swap_partition
				break
				;;
			"none") break ;;
			*) echo "Please answer file or partition." ;;
		esac
	done
}

#MUST BE FIXED
partiting_swap_file(){
	display_message "Create the SWAP file"

	truncate -s 0 /swap/swapfile
	chattr +C /swap/swapfile
	btrfs property set /swap/swapfile compression none

	#Set 4 GB size to Swap file
	dd if=/dev/zero of=/swap/swapfile bs=4G count=2 status=progress
	
	#Give the right permissions to the swap file
	chmod 600 /swap/swapfile
	mkswap /swap/swapfile
	swapon /swap/swapfile

	#Enable the Swap file on boot
	echo -e "\n#Swapfile\n/swap/swapfile none swap defaults 0 0" >> /etc/fstab
	
	#Check /etc/fstab file
	tools_edit_file /etc/fstab #text

    display_message_success "SWAP file has been configured"
}

partiting_swap_partition(){
	display_message "Create the SWAP partition"

	mkswap -f $PARTITION_SWAP
	swapon $PARTITION_SWAP

    display_message_success "SWAP partiton has been configured"
}

#############################
#Functions - Calling
#############################

calling_essential(){
	check_if_internet_connection_exists
	check_if_user_has_root_previledges

	variables_export_bios
	variables_export_virtualization
	variables_export_processor

	cd $ARCHLINUX_SCRIPT_PATH/
}

calling_part_01(){
	calling_essential

    changing_language_keyboard
    changing_language_default

    if [[ $IS_VIRTUALIATION != "kvm" ]]; then
        connecting_internet_wifi
        #connecting_ssh
    fi

    partiting_disk
    partiting_mounting
    install_system_base
    creating_fstab
    mount_chroot

    display_message_warning "Script has been finished!"
}

calling_part_02(){
	calling_essential

    partiting_swap
    changing_timezone
    changing_language
    changing_hostname
    enabling_support_32_bits
    tools_repositories_syncronize_pacman
    changing_password_root
    creating_new_user
    editing_sudo_properties
    install_support_ssh
    installing_bootloader

    display_message_success "Script has been finished!"
    display_message_warning "Verify if everything is ok and then go back to the livecd mode by typing:\n\t> $ exit"
}

calling_part_03(){
	calling_essential

    install_desktop_utils
    install_desktop_enviroment_main
    install_driver_audio
    install_driver_bluetooth
    install_driver_printer
    install_driver_graphic_video
    install_network_interface
	install_softwares_pacman_essential
	install_softwares_pacman_extra
	install_softwares_pacman_manually
	install_softwares_binary
	install_support_qemu
	install_shell_zsh

    database_software_reflector

	tools_backup_create "After install ArchLinux"

    display_message_success "Script has been finished!"
	display_message_warning "Type:\n\t> $ exit\n\t> $ umount -a\n\t> $ systemctl reboot"
}

calling_part_04(){
	install_support_debtap
	install_support_docker
	install_support_flatpak
	install_support_pip
	install_support_podman
	install_support_snap
	install_support_wine

	tools_backup_create "After install platforms softwares support"
}

calling_part_05(){
	#install_softwares_binary
	install_softwares_github
	install_softwares_aur
	install_softwares_compilation
	install_softwares_flatpak
	install_softwares_pip

	tools_repositories_syncronize_aur
	tools_repositories_syncronize_pacman

	tools_backup_create "After install useful softwares"
}

calling_testing(){
	#display_message "Hello world!"
	#display_message_success "Hello world!"
	#display_message_error "Hello world!"
	#display_message_warning "Hello world!"

	#echo -e "$TERMINAL_TEXT_BLINK blink (new in 0.52) $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_BOLD bold $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_BOLD_AND_ITALIC bold italic $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_ITALIC italic $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_REVERSE reverse $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_STRIKETHROUGH strikethrough $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_UNDERLINE underline $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_YYY Hello World $TERMINAL_TEXT_END"
	#echo -e "$TERMINAL_TEXT_ZZZ Hello World $TERMINAL_TEXT_END"

	#echo -e "$TERMINAL_TEXT_BACKGROUND_WHITE_CYAN 256-color background, de jure standard (ITU-T T.416) $TERMINAL_TEXT_BACKGROUND_END"
	#echo -e "$TERMINAL_TEXT_BACKGROUND_WHITE_ORANGE truecolor background, de jure standard (ITU-T T.416) (new in 0.52) $TERMINAL_TEXT_BACKGROUND_END"

	check_if_internet_connection_exists
	#connecting_internet_wifi
}

#############################
#Calling the functions
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-p1" | "--part-01") calling_part_01 ;;
	"-p2" | "--part-02") calling_part_02 ;;
	"-p3" | "--part-03") calling_part_03 ;;
	"-p4" | "--part-04") calling_part_04 ;;
	"-p5" | "--part-05") calling_part_05 ;;
	"-t" | "--testing") calling_testing ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
