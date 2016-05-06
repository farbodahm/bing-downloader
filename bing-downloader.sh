#!/bin/bash

#xml file link
xml="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1"

#bing site
bing="http://www.bing.com"

#size
#Note: In most cases "1366x768" work better!
size="1920x1200"

#path to download file
path="/home/$USER/bing"

#path to save log file
log="/home/$USER/bing/bing.log"

###################################################################
#Don't Change Below Codes If You Want To Run Code Successfully :)#
###################################################################

#make $path dir when there is no $path dir!
if [[ ! -e "$path" ]]
then
	mkdir "$path"
fi

#get xml file
xfile=$(wget "$xml" -q -O -)

#regex to get url
url=$(echo $xfile | egrep -o '<url>.*<\/url>')

#regex to get only url
image_url=$(echo $url | egrep -o '\/.+jpg')

#change 1366x768 to $size
image_url=$(echo $image_url | sed s/1366x768/$size/g)

#full address
full_add=$bing$image_url

#get image name
name=$(echo $image_url | egrep -o '([^\/]+)\/?$' )

#Check if that image doesnt have $size change it to defult size (1366x768)!
link=$(curl -s --head $full_add | head -n 1 | egrep -o "200 OK")
if [[ $link != "200 OK" ]]
then
	echo "The '$full_add' doesent have '$size' size, so i change it to defult size!" >> "$log"
	full_add=$(echo $full_add | sed s/$size/1366x768/g)
fi

#check if file doesnt exists download it!
if [[ ! -f "$path/$name"  ]]
then
	#download image :)
	echo "Downloading New Picture..." >> "$log"
	wget -P "$path" -a "$log" $full_add
	#set new picture to background
	gsettings set org.gnome.desktop.background picture-uri "file://$path/$name"
fi
