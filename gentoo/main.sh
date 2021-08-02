#!/usr/bin/env sh

#############################
#Variables
#############################

GENTOO_SCRIPT_LINK="https://raw.githubusercontent.com/henrikbeck95/testing/main/gentoo"
GENTOO_SCRIPT_PATH="/root"

PARTITION_PATH="/dev/vda" #/dev/sda
PARTITION_BIOS="/dev/vda1"
PARTITION_BOOT="/dev/vda2"
PARTITION_SWAP="/dev/vda3"
PARTITION_ROOT="/dev/vda4"

#############################
#Functions
#############################

display_message(){
	echo -e "\n#############################\n#$1\n#############################\n"
}

setup_installation_script_download(){
	cd $GENTOO_SCRIPT_PATH/
	
	display_message "Downloading the scripts"
	curl -L -O $GENTOO_SCRIPT_LINK/main.sh
	curl -L -O $GENTOO_SCRIPT_LINK/gentoo_part_1.sh
	curl -L -O $GENTOO_SCRIPT_LINK/gentoo_part_2.sh
	curl -L -O $GENTOO_SCRIPT_LINK/gentoo_part_3.sh
	
	display_message "Giving the executable permission to the scripts"
	chmod +x $GENTOO_SCRIPT_PATH/main.sh
	chmod +x $GENTOO_SCRIPT_PATH/gentoo_part_1.sh
	chmod +x $GENTOO_SCRIPT_PATH/gentoo_part_2.sh
	chmod +x $GENTOO_SCRIPT_PATH/gentoo_part_3.sh
}

#############################
#Calling the functions
#############################

setup_installation_script_download