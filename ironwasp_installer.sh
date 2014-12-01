#!/bin/bash
echo "======================================================================================= "
echo "|  _____  _______      ___   ____  _____  ____      ____  _       ______   _______    | "
echo "| |_   _||_   __ \   .'   \`.|_   \|_   _||_  _|    |_  _|/ \    .' ____ \ |_   __ \  | "
echo "|   | |    | |__) | /  .-.  \ |   \ | |    \ \  /\  / / / _ \   | (___ \_|  | |__) |  | "
echo "|   | |    |  __ /  | |   | | | |\ \| |     \ \/  \/ / / ___ \   _.____\`.   |  ___/  | "
echo "|  _| |_  _| |  \ \_\  \`-'  /_| |_\   |_     \  /\  /_/ /   \ \_| \____) | _| |_     | "
echo "| |_____||____| |___|\`.___.'|_____|\____|     \/  \/|____| |____|\______.'|_____|    | "
echo "|                                                                                     | "
echo "======================================================================================= "
echo "                          IRONWASP Linux / MAC Installer                                "
echo ""
echo "Will automatically install and configure IRONWASP."
echo "All you need to click is next next next"
echo ""
echo "Script Written by Anant shrivastava http://anantshri.info"
echo "Grab the latest script here : https://github.com/anantshri/ironwasp_installer"
echo ""
# check if wine is installed.
if [ -a "${HOME}/IRONWASP/" ]
then
	echo "Please rename IRONWASP directory in your home folder"
	echo "This might be present if you have run this script before"
	echo "In case you already have Ironwasp"
	echo "IronWASP will automatically call for update"
	echo "Thanks for using the script"
	exit
fi
read -p "press any key to continue" input_cmd
if which wine >/dev/null
then
	echo "Creating directories"
	export WINEARCH=win32
	PTH="${HOME}/IRONWASP"
	iPTH=$PTH"/installer"
	mkdir $PTH
	echo "Starting Wine configuration"
	WINEPREFIX=$PTH wineboot
	mkdir $iPTH
	wget http://winetricks.org/winetricks -O $iPTH/winetricks
	chmod 755 $iPTH/winetricks
	WINEPREFIX=$PTH sh $iPTH/winetricks dotnet20sp2 fontfix
	wget http://ironwasp.org/ironwasp.zip -O $iPTH/ironwasp.zip
	unzip $iPTH/ironwasp.zip -d $PTH/drive_c/
	if [ "$(uname)" == "Darwin" ]
	then
		echo "MacOSX detected"
		echo "Creating a mac application"
	    if [ -a "$PTH/MACApp/IronWASP.app" ]
	    then
	    	echo "IronWASP Application entry already exist"
	    	echo "Rerun the whole setup if you thing this is wrong"
	    	exit
	    else
	    	echo "Installing the IronWASP Application"
		    mkdir -p "$PTH/MACApp/IronWASP.app/Contents/MacOS"
		    echo "#!/bin/bash" > $PTH/MACApp/IronWASP.app/Contents/MacOS/IronWASP
		    echo "cd $PTH"  >> $PTH/MACApp/IronWASP.app/Contents/MacOS/IronWASP
			echo "WINEPREFIX=$PTH wine 'c:/IronWASP/IronWASP.exe'" >> $PTH/MACApp/IronWASP.app/Contents/MacOS/IronWASP
		    chmod +x $PTH/MACApp/IronWASP.app/Contents/MacOS/IronWASP
		    ln -s $PTH/MACApp/IronWASP.app ~/Applications/IronWASP.app 
		fi
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
	then
		echo "Linux Detected"
		echo "Shortcut created on desktop"
		echo "#!/bin/bash" > ~/Desktop/IronWasp
		echo "cd $PTH" >> ~/Desktop/IronWasp
		echo "WINEPREFIX=$PTH wine 'c:/IronWASP/IronWASP.exe'" >> ~/Desktop/IronWasp
		chmod +x ~/Desktop/IronWasp
	fi
	
else
    echo "We need Wine for this process to work properly"
    echo "Please install wine as per your system"
    exit "you may want to check apt-get , yum, brew, macport before downloading "
fi