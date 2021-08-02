#!/usr/bin/env sh

source "$(pwd)/main.sh"

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
	display_message ""
	
	iwctl #Wi-fi connect
	#device list
	#station wlan0 scan
	#station wlan0 get-networks
	#station wlan0 connect <wireless network name>
	#exit
	
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
	cfdisk $PARTITION_PATH
	
	#Formatting the partitions
	mkfs.fat -F32 $PARTITION_BOOT
	#mkfs.fat -F32 -n ESP $PARTITION_BOOT
	#mkfs.fat -F32 -n BOOT $PARTITION_BOOT
	mkfs.btrfs -f $PARTITION_ROOT

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
			mkdir -p /mnt/boot/
			mount $PARTITION_BOOT /mnt/boot/
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

	pacstrap /mnt/ base linux linux-firmware vim btrfs-progs

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

display_message "Script has been finished!"