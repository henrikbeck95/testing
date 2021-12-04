#!/usr/bin/env sh

#############################
#Functions
#############################

export_variables_bios(){
	ARCHLINUX_SCRIPT_LINK="https://raw.githubusercontent.com/henrikbeck95/testing/main/archlinux"
	ARCHLINUX_SCRIPT_PATH="/root"

	BIOS=$(ls -A /sys/firmware/efi/efivars 2>&1 /dev/null) #Verifying if BIOS supports UEFI

	#Verifying if BIOS supports UEFI by checking if directory is empty
	if [ -z "$(ls -A /sys/firmware/efi/efivars)" ]; then
		IS_BIOS_UEFI="legacy" #echo "Empty"
	else
		IS_BIOS_UEFI="uefi" #"Not Empty"
	fi

	display_message_warning "Your device BIOS is $IS_BIOS_UEFI"
}

export_variables_virtualization(){
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

export_variables_processor(){
	PROCESSOR=$(cat /proc/cpuinfo | grep vendor_id | head -1 | awk '{print $3}')
	#PROCESSOR=$(cat /sys/devices/virtual/dmi/id/board_{vendor,name,version})

	display_message_warning "Your device processor family is $PROCESSOR"
}

display_message(){
	echo -e "\n#############################\n#$1\n#############################\n"
}

display_message_warning(){
	echo -e "\n***$1***"
}

display_message_error(){
	echo -e "\n#############################\n#Error! $1\n#############################\n"
}

setup_installation_script_download(){
	cd $ARCHLINUX_SCRIPT_PATH/
	
	display_message "Downloading the scripts"
	curl -L -O $ARCHLINUX_SCRIPT_LINK/main.sh
	curl -L -O $ARCHLINUX_SCRIPT_LINK/archlinux_part_1.sh
	curl -L -O $ARCHLINUX_SCRIPT_LINK/archlinux_part_2.sh
	curl -L -O $ARCHLINUX_SCRIPT_LINK/archlinux_part_3.sh
	
	display_message "Giving the executable permission to the scripts"
	chmod +x $ARCHLINUX_SCRIPT_PATH/main.sh
	chmod +x $ARCHLINUX_SCRIPT_PATH/archlinux_part_1.sh
	chmod +x $ARCHLINUX_SCRIPT_PATH/archlinux_part_2.sh
	chmod +x $ARCHLINUX_SCRIPT_PATH/archlinux_part_3.sh
}

#############################
#Calling the functions
#############################

export_variables_bios
export_variables_virtualization
export_variables_processor

setup_installation_script_download