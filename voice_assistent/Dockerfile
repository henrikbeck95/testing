FROM ubuntu:21.04
MAINTAINER Henrik Beck <henrikbeck95@gmail.com>

#############################
#Version 0.1 - Installing essential tools
#############################

#Update system
RUN apt update && \
	apt install -y tzdata software-properties-common && \
	add-apt-repository -y -u ppa:certbot/certbot && \
	apt install -y certbot

#Install essential softwares
RUN apt install -y bash-completion wget doxygen python3-pip python3-all-dev

#Install Python-Pip libraries
RUN pip3 install python-dev-tools && \
	pip3 install pytest && \
	pip3 install pyttsx3 && \
	pip3 install wikipedia && \
	pip3 install SpeechRecognition && \
	pip3 install pywhatkit && \
	pip3 install numpy

#Apply Vi customization
#echo "set ts=4 sw=4" >> /etc/virc && \

#Install Vim and LF terminal file manager
RUN \
	apt install -y vim && \
	wget https://github.com/gokcehan/lf/releases/download/r24/lf-linux-amd64.tar.gz && \
	tar -zxf ./lf-linux-amd64.tar.gz && \
	mv -v ./lf /bin/ && \
	rm -f ./lf-linux-amd64.tar.gz

#Install PyAudio
RUN apt install -y python3-pyaudio
RUN apt install -y jackd1
#RUN apt install libasound-dev portaudio19-dev libportaudio2 libportaudiocpp0
#RUN apt install -y libasound2 

#CentOS 7 softwares
#RUN apt install sox libtool autoconf bison swig alsa-lib-devel pulseaudio-libs-devel make -y

#############################
#Version 0.5 - Copying files
#############################

#Attribute the variables values
#WORKDIR /voice_assistent/

#Copy the Voice Assistent for Linux files to container
#COPY . /voice_assistent/

#############################
#Version 1.0 - Running...
#############################

#Update Python-pip and all Python-Pip packages
#RUN pip3 install --upgrade pip && pip3 install --upgrade $(pip3 freeze | awk '{split($0, a, "=="); print a[1]}')

#Execute Voice assistent
#RUN pip install -e .
#RUN /home/$USER/.local/bin/pytest
#python -m speech_recognition

#CMD python3 /home/$USER/voice_assistent/src/__init__.py
#CMD python3 -m speech_recognition
#CMD aplay ...

#docker run -it --rm --privileged=true --device=/dev/snd:/dev/snd myContainerName jackd -R -d alsa -d hw:1
#aplay a.wav #ALSA alsa-utils
#play a.mp3 #Sox
#test
#python -m speech_recognition

#CMD python3 /home/$USER/voice_assistent/src/__init__.py
#CMD python3 -m speech_recognition
#CMD aplay ...

#docker run -it --rm --privileged=true --device=/dev/snd:/dev/snd myContainerName jackd -R -d alsa -d hw:1
#aplay a.wav #ALSA alsa-utils
#play a.mp3 #Sox
