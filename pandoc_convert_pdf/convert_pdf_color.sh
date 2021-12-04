#!/usr/bin/env sh

#podman run --volume $(pwd):/tmp/ docker.io/henrikbeck95/convert-pdf-color /converting.sh --container

#############################
#Variables
#############################

AUX1=$1
YOUR_HOST_PATH=$(pwd)

#SOFTWARE="docker"
SOFTWARE="podman"
SOFTWARE_REPOSITORY="docker.io"
#SOFTWARE_REPOSITORY="localhost"
SOFTWARE_IMAGE_NAME="henrikbeck95/convert_pdf_color"
SOFTWARE_IMAGE_VERSION="v1.0"

#CONTAINER_NAME="convert_pdf"

FILE_INPUT="/tmp/input.pdf"
FILE_OUTPUT="/tmp/output.pdf"

MESSAGE_HELP="
\t\t\tConvert PDF color
\t\t\t-----------------\n
[Description]
Specific color converter for PDF documents.

By default the PDF filename must be **input.pdf** and it must be storage in the root of the project. Otherwise the file is not going to be converted.

The converted result is going to recieve the **output.pdf** filename.

[Parameters]
-h\t--help\t-?\t\tDisplay this help message
-e\t--editor\t\tEdit this script file
-b\t--build\t\tBuild the container image
-c\t--convert\t\tConvert PDF color
-cd\t--convert-debug\tConvert PDF colors (debug mode)
-l\t--list\t\t\tList all files inside the current folder
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

#Testing
build_container(){
	case $SOFTWARE in
		"docker")
			display_message "Building $SOFTWARE $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION..."
			docker build --tag $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION .
			;;
		"podman")
			display_message "Building $SOFTWARE $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION..."
			buildah bud --layers=true --tag $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION .
			;;
		*)
			echo -e "$MESSAGE_ERROR"
			exit 0
			;;
	esac
}

display_message(){
	echo -e "\n#############################\n#$1\n#############################"
}

list_files(){
	ls -la
}

notification(){
	notify-send "$1"
}

convert_pdf_color(){
	display_message "Converting $FILE_INPUT to $FILE_OUTPUT"

	$SOFTWARE run \
		--volume /$YOUR_HOST_PATH:/tmp/ $SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME \
		/converting.sh --container

	#$SOFTWARE run \
		#--volume /$YOUR_HOST_PATH:/tmp/ $SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION \
		#/converting.sh --container
		
	#/converting.sh --host
		#$FILE_INPUT $FILE_OUTPUT
		#convert $FILE_INPUT $FILE_OUTPUT
		#--name $CONTAINER_NAME \

	notification "Convertion has been completed"
}

convert_pdf_color_debug(){
	display_message "Listing $YOUR_HOST_PATH/ files (before convertion)..."
	list_files

	convert_pdf_color

	display_message "Listing $YOUR_HOST_PATH/ files (after convertion)..."
	list_files

	notification "Convertion has been completed"
}

#############################
#Calling the functions
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--editor") $EDITOR $0 ;;
	"-b" | "--build") build_container ;;
	"-c" | "--convert") convert_pdf_color ;;
	"-cd" | "--convert-debug") convert_pdf_color_debug ;;
	"-l" | "--list") list_files ;;
	"-p" | "--podman") create_image_podman_from_dockerfile ;;
	*) echo -e "$MESSAGE_HELP" ;;
esac
