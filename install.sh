#!/bin/bash
flags="--noconfirm  --needed"
BLU='\033[0;34m'
RED='\033[0;31m'
YEL='\033[0;33m'
NC='\033[0m' 
if [ "$(pwd)" = "/home/$(whoami)/.config/dotConfig" ]; then
	echo -e "${BLU}\n░░░░█████╗░░█████╗░███╗░░██╗███████╗██╗░██████╗░"
	echo -e "${BLU}░░░██╔══██╗██╔══██╗████╗░██║██╔════╝██║██╔════╝░"
	echo -e "${BlU}░░░██║░░╚═╝██║░░██║██╔██╗██║█████╗░░██║██║░░██╗░"
	echo -e "${BLU}░░░██║░░██╗██║░░██║██║╚████║██╔══╝░░██║██║░░╚██╗"
	echo -e "${BLU}██╗╚█████╔╝╚█████╔╝██║░╚███║██║░░░░░██║╚██████╔╝"
	echo -e "${BLU}╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░░░░╚═╝░╚═════╝░"
else
	cd ~/.config/
	git clone https://github.com/Capita1/dotConfig.git
	cd dotConfig/
	sh install.sh
fi

echo -e "${YEL}\nConfigs\n${NC}"
#copia configs
apagar="$(ls -h config/)"
cd ../
sudo rm -rf $apagar
cd dotConfig/
cp -rf config/* ../
#links em bin
sudo ln -rsf scripts/menus /bin/
#links em home
sudo rm ~/.bashrc ;  sudo rm ~/.profile 
sudo ln -rsf home/.* ~/ 
#links em hosts
sudo rm /etc/hosts 
sudo ln -rsf etc/hosts /etc/ 

if [ "$1" = "-n" ]; then
	echo "-n pra não baixar nada"
else
	echo -e "${YEL}\nAtualizando...\n${NC}"
	sudo pacman -Syu $flags base-devel  
	echo -e "${YEL}\nBaixando Apps...\n${NC}"
	#Interface
	sudo pacman -S $flags hyprland swaync waybar wofi wpaperd nwg-look polkit-kde-agent xdg-desktop-portal-gtk xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-hyprland hyprsunset hyprlock
	#Audio
	sudo pacman -S $flags gst-plugin-pipewire lib32-libpipewire libpipewire pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse wireplumber
	#Apps
	sudo pacman -S $flags kitty pavucontrol blueman thunar thunar-media-tags-plugin thunar-shares-plugin thunar-volman ffmpegthumbnailer tumbler gvfs gparted grim slurp gvfs-smb smbclient
	#Texto
	sudo pacman -S $flags neovim mousepad zathura zathura-pdf-mupdf 
	#Midia
	sudo pacman -S $flags feh mpd mpd-mpris rmpc mpv playerctl
	#CLI
	sudo pacman -S $flags fastfetch btop awk less libnotify yt-dlp ffmpeg cliphist wl-clipboard unzip github-cli flatpak tesseract-data-eng
	#Fontes
	sudo pacman -S $flags ttf-nerd-fonts-symbols-mono ttf-terminus-nerd adobe-source-code-pro-fonts
fi
if pgrep -x "Hyprland" > /dev/null ; then
	hyprctl dispatch exec menus temas Simples
	hyprctl reload
else
	echo "Hyprland não aberto"
fi
