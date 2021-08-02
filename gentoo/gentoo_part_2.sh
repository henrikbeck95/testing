#!/usr/bin/env sh

source "$(pwd)/main.sh"

#############################
#Functions
#############################

chroot_mount_part_2(){
	display_message "Loading the profile variables settings"
	source /etc/profile
	
	display_message "Editing the Chroot prefix lable"
	export PS1="(chroot) ${PS1}"

	display_message "Mounting the boot partition"
	mount $PARTITION_BOOT /boot
}

install_update_ebuild_snapshot_webrsync(){
	display_message "Installing update ebuild snapshot web-rsync"
	emerge-webrsync
	emerge --sync
}

choosing_the_right_profile(){
	display_message "Choosing the right profile for Gentoo"
	eselect profile list
	
	read -p "Inform the Gentoo profile index you want: " QUESTION
    eselect profile set $QUESTION
}

update_the_world_set(){
	#nano /etc/portage/make.conf
	display_message "Reading the Gentoo system relatories"
	eselect news read | more
	
	display_message "Update the Gentoo"
	emerge  --ask --verbose --update --deep --newuse @world
}

timezone_openrc(){
	display_message "Updating timezone - OpenRC"
	#ls /usr/share/zoneinfo/
	echo "Brazil/East" > /etc/timezone
	emerge --config sys-libs/timezone-data
}

timezone_systemd(){
	display_message "Updating timezone - Systemd"
	ln -sf ../usr/share/zoneinfo/Europe/Brussels /etc/localtime
}

locale_generation(){
	display_message "Generating locale"
	#nano -w /etc/locale.gen
	echo -e "pt_BR UTF-8" > /etc/locale.gen
	locale-gen
	
	display_message "Listing all the generated locale"
	locale -a
	
	display_message "Listing all the locale options"
	eselect locale list
	
	read -p "Inform the Gentoo locale index you want: " QUESTION
    eselect locale set $QUESTION #5
}

reload_environment(){
	display_message "Updating environment variables"
	env-update && source /etc/profile && export PS1="(chroot) $PS1"
	
	emerge --ask sys-apps/pciutils
}

gentoo_kernel(){
	display_message "Downloading the Gentoo kernel"
	emerge --ask sys-kernel/gentoo-sources
	
	display_message "Installing the Genkernel"
	emerge --ask sys-kernel/genkernel
	ls -l /usr/src/linux
	
	display_message ""
	#nano -w /etc/fstab
	echo -e "$PARTITION_BOOT\t\t/boot\t\tvfat\t\tdefaults\t\t0 2
	$PARTITION_ROOT\t\tnone\t\tswap\t\tsw\t\t0 0
	$PARTITION_SWAP\t\t/\t\text4\t\tnoatime\t\t0 1" >> /etc/fstab
	
	display_message "Installing the Gentoo kernel"
	genkernel all
	
	ls /boot/vmlinu* /boot/initramfs*
	
	#display_message "Kernel modules"
	display_message "Installing firmware"
	emerge --ask sys-kernel/linux-firmware
	#display_message ""
}

domain_hostname(){
	display_message "Setting the hostname domain"	
	read -p "Inform the Gentoo hostname you want: " QUESTION_HOSTNAME #biomachine
	echo -e "# Set to the hostname of this machine\nhostname=\"$QUESTION_HOSTNAME\"" > /etc/conf.d/hostname
}

domain_dns(){
	display_message "Setting the DNS domain"
	read -p "Inform the Gentoo dns you want: " QUESTION_DNS #gentoolinux
	echo -e "dns_domain_lo=\"$QUESTION_DNS\"" > /etc/conf.d/net
}

configure_network(){
	display_message "Configuring the network"
	emerge --ask noreplace net-misc/netifrc
	echo -e "config_enps03=\t"dhcp\t"" > /etc/conf.d/net
	ln -s net.lo net.enps03
	rc-update add net.enps03 default
}

change_password(){
	display_message "Changing the Root password"
	nano /etc/security/passwdqc.conf #Change min=8.8.8.8.8 to min=1.1.1.1.1
	
	passwd
}

init_and_boot_configuration(){
	display_message "Configuring the init and boot"
	nano -w /etc/rc.conf
	nano -w /etc/conf.d/keymaps
	nano -w /etc/conf.d/hwclock #clock="local"
}

installing_tools(){
	display_message "Installing tools"
	emerge --ask app-admin/sysklogd
	rc-update add sysklogd default
	
	emerge --ask e2fsprogs #Ext 2, Ext3 and Ext4
	emerge --ask dosfstools #VFat and Fat 32
	emerge --ask btrfs-progs #BTRFS
	
	emerge --ask net-misc/dhcpcd
	
	#emerge --ask net-wireless/iw net-wireless/wpa_supplicant
}

grub_settings(){
	display_message "Configuring GRUB"
	#emerge --ask --verbose sys-boot/grub:2 #No
	echo -e "GRUB_PLATFORMS=\"efi-64\"" >> /etc/portage/make.conf
	emerge --ask sys-boot/grub:2 #Yes
	
	#grub-install $PARTITION_PATH #For BIOS Legacy system
	#grub-install --target=x86_64-efi --efi-directory=/boot #For UEFI system
	#grub-mkconfig -o /boot/grub/grub.cfg
}

#############################
#Calling the functions
#############################

chroot_mount_part_2
install_update_ebuild_snapshot_webrsync
choosing_the_right_profile
update_the_world_set
timezone_openrc
#timezone_systemd
locale_generation
reload_environment
gentoo_kernel
domain_hostname
domain_dns
configure_network
change_password
init_and_boot_configuration
installing_tools
grub_settings

reboot