#!/usr/bin/env sh

source "$(pwd)/main.sh"

#############################
#Functions
#############################

keyboard_layout(){
	display_message "Setting keyboard layout to Portuguese ABNT2"
	loadkeys br-abnt2
}

partitions_creation(){
	display_message "Create the partitions according to the following method:\n
	Bios partition: $PARTITION_BIOS (GRUB)
	Boot partition: $PARTITION_BOOT
	Swap partition: $PARTITION_SWAP
	Root partition: $PARTITION_ROOT"

	while true; do
		read -p "Do you want to procedure? [Y/n] " QUESTION_PARTITION
		case $QUESTION_PARTITION in
			[Yy]*) break ;;
			[Nn]*) : ;;
			*) echo "Please answer Y for yes or N for no." ;;
		esac
	done
	
	cfdisk
	
	display_message "Configuring the partitions"
	mkfs.vfat $PARTITION_BIOS
	mkfs.fat -F32 $PARTITION_BOOT
	mkswap -f $PARTITION_SWAP
	swapon $PARTITION_SWAP
	mkfs.btrfs -f $PARTITION_ROOT
}

partitions_mount(){
	display_message "Mounting the Gentoo partition"
	mount $PARTITION_ROOT /mnt/gentoo/
	cd /mnt/gentoo/
	#chmod 1777 /mnt/gentoo/tmp/
}

system_stage3(){
	display_message "Downloading the Gentoo Stage 3 compacted file"
	curl -L -O https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210725T170534Z/stage3-amd64-openrc-20210725T170534Z.tar.xz

	display_message "Extracting the Gentoo Stage 3 compacted file"
	tar xpvf stage3-amd64-openrc-20210725T170534Z.tar.xz --xattrs-include='*.*' --numeric-owner
}

compile_settings(){
	display_message "Changing the compiler settings file: /mnt/gentoo/etc/portage/make.conf"
	
	#nano -w /mnt/gentoo/etc/portage/make.conf
	#wget https://raw.githubusercontent.com/gentoo/portage/master/cnf/make.conf.example -O /mnt/gentoo/etc/portage/make.conf

	#echo -e '# These settings were set by the catalyst build script that automatically
	## build this stage.
	## Please consult /usr/share/portage/config/make.conf.example for a more
	## detailed example.
	#CHOST=x86_64-pc-linux-gnu
	#COMMON_FLAGS="-02 -march=znver2 -pipe"
	#CFLAGS="${COMMON_FLAGS}"
	#CXXFLAGS="${COMMON_FLAGS}"
	#FCFLAGS="${COMMON_FLAGS}"
	#FFLAGS="${COMMON_FLAGS}"
	#MAKEOPT="-j12"
	#ACCEPT_LICENSE="*"
	#USE="-systemd -qtwebengine -webengine -sqlite" #Exclude these softwares
	
	## NOTE: This stage was built with the bindist use flag enabled
	#PORTDIR="/var/db/repos/gentoo"
	#DISTDIR="/var/cache/distfiles"
	#PKGDIR="/var/cache/binpkgs"
	
	## This sets the language of build output to English.
	## Please keep this setting intact when reporting bugs.
	#LC_MESSAGES=C' > /mnt/gentoo/etc/portage/make.conf
	
	echo -e "ACCEPT_LICENSE=\"*\"" >> /mnt/gentoo/etc/portage/make.conf
	
	display_message "Setting the mirror to the compiler configuration file"
	
	while true; do
		read -p "Do you want to procedure? [Y/n] " QUESTION_MIRROR
		case $QUESTION_MIRROR in
			[Yy]*) break ;;
			[Nn]*) : ;;
			*) echo "Please answer Y for yes or N for no." ;;
		esac
	done
	
	mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
}

system_base(){
	display_message "Prepating ???"
	mkdir -p /mnt/gentoo/etc/portage/repos.conf/
	
	cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
	cp -L /etc/resolv.conf /mnt/gentoo/etc/
}

chroot_mount_part_1(){
	display_message "Mounting the ???"
	mount --types proc /proc/ /mnt/gentoo/proc/
	mount --rbind /sys/ /mnt/gentoo/sys/
	mount --make-rslave /mnt/gentoo/sys/
	mount --rbind /dev/ /mnt/gentoo/dev
	mount --make-rslave /mnt/gentoo/dev

	display_message "Logging as Chroot"
	chroot /mnt/gentoo /bin/bash
}

#############################
#Calling the functions
#############################

keyboard_layout
partitions_creation
partitions_mount
system_stage3
compile_settings
system_base
chroot_mount_part_1