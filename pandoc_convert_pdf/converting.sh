#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1
COLOR_NEW="blue"
COLOR_OLD="black"
FILE_INPUT="input.pdf"
FILE_OUTPUT="output.pdf"

MESSAGE_HELP="
\t\t\tConverting PDF colors
\t\t\t---------------------\n
-h\t--help\t-?\t\tDisplay this help message
-e\t--edit\t\t\tEdit this script file
-c\t--container\t\tConvert PDF colors from container
-h\t--host\t\t\tConvert PDF colors from host machine
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

#############################
#Functions
#############################

convert_pdf_color_host(){
	magick convert -density 300 \
		$FILE_INPUT -fill $COLOR_NEW \
		-opaque $COLOR_OLD $FILE_OUTPUT
}

convert_pdf_color_container(){
	magick convert -density 300 \
		/tmp/$FILE_INPUT -fill $COLOR_NEW \
		-opaque $COLOR_OLD /tmp/$FILE_OUTPUT
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-c" | "--container") convert_pdf_color_container ;;
	"-h" | "--host") convert_pdf_color_host ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
