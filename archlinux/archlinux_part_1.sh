#!/usr/bin/env sh

PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
source "$PATH_SCRIPT/main.sh"

#############################
#Functions
#############################

changing_language_keyboard(){
	display_message "Changing the keyboard layout settings"
	loadkeys br-abnt2
}

changing_language_default(){
	display_message "Changing for Brazilian Portuguese keymap"

	#Uncomment the line: # pt_BR.UTF-8 UTF-8
	local FILENAME="/etc/locale.gen"

	TEXT_OLD="#pt_BR.UTF-8 UTF-8"
	TEXT_NEW="pt_BR.UTF-8 UTF-8"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

	#vim $FILENAME
	
	#Apply the new settings
	export LANG=pt_BR.UTF-8
}

connecting_internet(){
	display_message "iwctl Wi-Fi connect\n\n> #device list\n> #station wlan0 scan\n> #station wlan0 get-networks\n> #station wlan0 connect <wireless network name>\n> #exit"
	
	iwctl #Wi-fi connect
	ping -c 3 archlinux.org
}

#MUST BE TESTED
#MUST BE IMPLEMENTED SED CUT FUNCTION
connecting_ssh(){
	display_message "Install OpenSSH software"
	pacman -Syy openssh
	systemctl enable --now sshd.service
	nano /etc/ssh/sshd_config #Uncomment the port 22
	
	display_message "Change Root password"
	passwd root
	
	display_message "Get the ip address"
	ip addr
	
	display_message "Auxiliar machine"
	echo -e "Auxiliar machine
	
	For rightly configuring the another PC with Linux, follow the steps below:
	
	$ sudo apt install openssh-client
	$ ssh -l <username> <ip_address>
	or $ ssh root@<ip_address>
	or $ ssh-keygen -f \"/home/your_user/.ssh/known_hosts\" -R \"192.168.1.221\""
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
}

#MUST BE FIXED
partiting_mounting(){
	display_message "Mount the partitions"

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
}

install_system_base(){
	display_message "Install the system base"

	pacstrap /mnt/ \
		base\
		btrfs-progs \
		linux-firmware \
		linux-lts \
		vim \

	case $PROCESSOR in
		"AuthenticAMD") pacstrap /mnt/ amd-ucode ;;
		"GenuineIntel") pacstrap /mnt/ intel-ucode ;;
		*)
			display_message_error "Your processor could not be identified!"
			exit 0
		;;
	esac
}

creating_fstab(){
	display_message "Generate the /etc/fstab file"
	genfstab -U /mnt >> /mnt/etc/fstab

	#Check if the /etc/fstab file was generated correctly
	cat /mnt/etc/fstab
}

chroot_mount_part_1(){
	display_message "Log in as root on the ArchLinux which is going to be installed (not the installer iso one)"
	arch-chroot /mnt/
}

#############################
#Calling the functions
#############################

changing_language_keyboard
changing_language_default

if [[ $IS_VIRTUALIATION != "kvm" ]]; then
	connecting_internet
	#connecting_ssh
fi

partiting_disk
partiting_mounting
install_system_base
creating_fstab
chroot_mount_part_1

display_message_warning "Script has been finished!"