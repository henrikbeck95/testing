#!/usr/bin/env sh

source "$(pwd)/main.sh"

#############################
#Functions
#############################

configuring_user(){
    adduser henrikbeck95
}

updating_system(){
	sudo emerge --sync #Update the system
	glsa-check -t all
	sudo glsa-check -f all #Force to be updated
	sudo emerge -avDuN @world #Update the softwares
}

installing_softwares(){	
    sudo emerge --ask app-editors/vim
	sudo emerge --ask kde-apps/dolphin
	sudo emerge --ask kde-apps/ark
	
	#sudo emerge --ask --verbose --depclean sddm
	
	#equery d sddm
	#sudo emerge --unmerge --ask kde-apps/dolphin
}

#############################
#Calling the functions
#############################

installing_softwares
configuring_user