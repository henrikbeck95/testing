#!/usr/bin/env sh

source "$(pwd)/main.sh"

#############################
#Functions
#############################

partiting_swap(){
	display_message "Create the SWAP"

	while true; do
		read -p "Inform you want: [file/partition/none] " QUESTION_SWAP

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
	vim /etc/fstab #text
}

#MUST BE TESTED
partiting_swap_partition(){
	display_message "Create the SWAP partition"

	mkswap -f $PARTITION_SWAP
	swapon $PARTITION_SWAP
}

changing_timezone(){
	display_message "Search for UTC time zone"
	timedatectl list-timezones | grep Sao_Paulo
	
	display_message "Apply the UTC time zone"
	ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	
	display_message "Sync UTC clock with the hardware machine"
	hwclock --systohc --utc #UTC clock
	#hwclock --systohc #Hardware clock
}

changing_language(){
	display_message "Change the language"
	#vim /etc/locale.gen #Uncomment the pt_BR.UTF-8 UTF-8 line
	locale-gen
	
	echo LANG=en_US.UTF-8 >> /etc/locale.conf
	#echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

	echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
}

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

				vim $FILENAME
				break
				;;
			[Nn]*) break ;;
			*) echo "Please answer Y for yes or N for no." ;;
		esac
	done
}

repositories_syncronize(){
	display_message "Apply the new ArchLinux settings and check for updates"
	pacman -Syu
}

changing_password_root(){
	display_message "Change the root password"
	passwd
}

creating_new_user(){
	display_message "Create a new user account to be ready to log in after the installation setup is done"

	read -p "Inform the username you want: " QUESTION_USERNAME #henrikbeck95
	useradd -mG wheel $QUESTION_USERNAME
	passwd $QUESTION_USERNAME
}

editing_sudo_properties(){
	display_message "Setting the Vim as the default text editor and also edit the visudo file"

	#Uncomment the line: # %wheel ALL=(ALL) ALL
	local FILENAME="/etc/sudoers"

	TEXT_OLD="# %wheel ALL=(ALL) ALL"
	TEXT_NEW="%wheel ALL=(ALL) ALL"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

	EDITOR=vim visudo
}

installing_support_ssh_connection(){
	display_message "Installing SSH connect support"
	pacman -S openssh
	systemctl enable sshd.service
}

#MUST BE FIXED
installing_packages_bootloader(){
	display_message "Installing packages for the bootloader and the network tools"
	pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers reflector cron

	#Enable the NetworkManager 
	systemctl enable NetworkManager.service

	#Configuring GRUB by commenting the line: MODULES=()
	local FILENAME="/etc/mkinitcpio.conf"

	TEXT_OLD="MODULES=()"
	TEXT_NEW="MODULES=(btrfs)"
	sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME

	#vim $FILENAME #Add text: MODULES=(btrfs)
	mkinitcpio -p linux

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
			;;
		*)
			display_message_error "The BIOS could not be identified!"
			exit 0
			;;
	esac
}

#############################
#Calling the functions
#############################

partiting_swap
changing_timezone
changing_language
changing_hostname
enabling_support_32_bits
repositories_syncronize
changing_password_root
creating_new_user
editing_sudo_properties
installing_support_ssh_connection
installing_packages_bootloader

display_message_warning "Script has been finished!"

echo -e "Verify if everything is ok and then go back to the livecd mode by typing: $ exit"