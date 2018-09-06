#!//bin/bash

clear
read -r -p  "home directory (user) for apps directory:" user

clear
echo "--------------------------------------------------------------------------------------"
echo "************************************* WARNING ****************************************"
echo "This script will install Blackmagic Device Driver and Blackmagic SDK (Version 10.11.1)"
echo "--------------------------------------------------------------------------------------"
echo ""
read -r -p  "Are you sure you want to continue?  (y/N): " continue


case "$continue" in
	[nN])
	echo "exiting script..."
	exit 1
	;;
esac

#Install Blackmagic Drivers on Host System
sleep 1
clear
echo "Installing Prerequisit Packages ....."
echo "" && echo "" && echo "" && echo "" && echo "" 
echo "Installing LINUX HEADERS ....."
sudo apt-get install -y linux-headers-$(uname -r)
echo "" && echo "" && echo ""
sleep 5

echo "Installing DKMS ....."
sudo apt-get install -y dkms
echo "" && echo "" && echo ""
sleep 5


echo "Installing Blackmagic Drivers on Host System ....."
cd /home/$user/apps/srt-connect-2/dockers/decklink-10.11.1/Blackmagic_Desktop_Video_Linux_10.11.1/deb/x86_64
sudo dpkg -i desktopvideo_10.11.1a4_amd64.deb
sudo apt-get install -y -f
echo "" && echo "" && echo ""
sleep 5


echo "Update Blackmagic Firmware ....."
read -r -p  "Do you wish to update firmware now? (y/N): " update
case "$update" in
	[yY])
	BlackmagicFirmwareUpdater update 0
	sleep 1
	BlackmagicFirmwareUpdater status
	;;
esac
echo "" && echo "" && echo ""
sleep 5

echo "Copying libDeckLinkAPI.so and libDeckLinkPreviewAPI.so to Decklink Docker build....."
sudo cp /usr/lib/libDeckLinkAPI.so /home/$user/apps/srt-connect-2/dockers/decklink-10.11.1
sudo cp /usr/lib/libDeckLinkPreviewAPI.so /home/$user/apps/srt-connect-2/dockers/decklink-10.11.1
sudo cp /usr/lib/libDeckLinkAPI.so /home/$user/apps/srt-connect-2/dockers/vlc
echo "Finished Blackmagic Setup....."
echo "" && echo "" && echo ""
sleep 5


# Install Docker and Docker Network
clear
echo "Installing Docker....."
read -r -p  "Do you wish to install Docker now? (y/N): " installDocker
case "$installDocker" in
	[yY])
	sudo apt-get remove docker docker-engine docker.io
	sudo apt-get update
	sudo apt-get install -y yapt-transport-https ca-certificates curl software-properties-common
	$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install -y --allow-unauthenticated docker-ce
	## network 
	sudo docker network create --gateway=10.0.10.1 --subnet=10.0.10.0/24 -d bridge split
	;;
	[nN])
	echo "skipping Docker install..."
esac
echo "" && echo "" && echo ""
sleep 5


read -r -p  "Do you wish to build Decklink Docker? (y/N): " buildDecklinkDocker
case "$buildDecklinkDocker" in
	[yY])
	echo "" && echo "" && echo ""
	echo "Building Decklink Docker"
	cd /home/$user/apps/srt-connect-2/dockers/decklink-10.11.1
	sudo docker build -t pmw1/decklink-10 .
	;;
	[nN])
	echo "Skipping Decklink Docker Build...."
	;;
esac
echo "" && echo "" && echo ""
sleep 5

##Build OBE Docker
read -r -p  "Do you wish to build OBE Docker? (y/N): " buildObeDocker
case "$buildObeDocker" in
	[yY])
	echo "" && echo "" && echo ""
	echo "Building OBE-RT Docker./..."
	cd /home/$user/apps/srt-connect-2/dockers/obe
	sudo docker build -t pmw1/obe-rt .
	;;
	[nN])
	echo "Skipping OBE-RT Docker Build...."
esac
echo "" && echo "" && echo ""
sleep 5

##Build VLC Docker
read -r -p  "Do you wish to build VLC Docker? (y/N): " buildVLCDocker
case "$buildVLCDocker" in
	[yY])
	echo "" && echo "" && echo ""
	echo "Building VLC Docker./..."
	cp -rf /home/$user/apps/srt-connect-2/dockers/decklink-10.11.1/Blackmagic_DeckLink_SDK_10.11.1.zip /home/$user/apps/srt-connect-2/dockers/vlc/BlackmagicSDK.zip
	cd /home/$user/apps/srt-connect-2/dockers/vlc
	sudo docker build --no-cache -t pmw1/vlc .
	;;
	[nN])
	echo "Skipping VLC Docker Build...."
esac


##Build SRT Docker
read -r -p  "Do you wish to build SRT Docker? (y/N): " buildSRTDocker
case "$buildSRTDocker" in
	[yY])
	echo "" && echo "" && echo ""
	echo "Building SRT Docker./..."
	cd /home/$user/apps/srt-connect-2/dockers/srt
	sudo docker build -t pmw1/srt .
	;;
	[nN])
	echo "Skipping srt Docker Build...."
esac


