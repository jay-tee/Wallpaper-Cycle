#!/bin/bash

path = /home/jt/Pictures
interval = $((60 * 60)) #change every 60 minutes
mode = "scaled" #none, centered, wallpaper, scaled, stretch, zoom, spanned

function change_wallpaper()
{
	mv $1 shown
	gsettings set org.gnome.desktop.background picture-uri file://$path/shown/$1
	gsettings set org.gnome.desktop.background picture-options $mode
}

function next_wallpaper()
{
    find . -maxdepth 1 -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | shuf -n 1
}

mkdir -p $path/shown
cd $path

while true; do
    next = $(next_wallpaper)

    if [[ "$next" == "" ]]; then
	cd shown
	find . -maxdepth 1 -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | xargs mv -t ..
	cd ..

	next = $(next_wallpaper)

	if [[ "$next" == "" ]]; then
	    echo "no wallpapers found in $path, will check in $interval seconds..."
	    sleep $interval
	    continue
        fi
    fi

    echo "changing background to $next"
    change_wallpaper $next
    sleep $interval

done
