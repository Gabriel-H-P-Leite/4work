#!/bin/bash
flags="--noconfirm  --needed"
BLU='\033[0;34m'
RED='\033[0;31m'
YEL='\033[0;33m'
NC='\033[0m' 
set -euo pipefail
if [ "$(pwd)" != "$HOME/.config/4work" ]; then
    echo "move essa pasta pra ~/.config/4work"
    exit 1
else
	echo -e "${BLU}\n░░░░█████╗░░█████╗░███╗░░██╗███████╗██╗░██████╗░"
	echo -e "${BLU}░░░██╔══██╗██╔══██╗████╗░██║██╔════╝██║██╔════╝░"
	echo -e "${BLU}░░░██║░░╚═╝██║░░██║██╔██╗██║█████╗░░██║██║░░██╗░"
	echo -e "${BLU}░░░██║░░██╗██║░░██║██║╚████║██╔══╝░░██║██║░░╚██╗"
	echo -e "${BLU}██╗╚█████╔╝╚█████╔╝██║░╚███║██║░░░░░██║╚██████╔╝"
	echo -e "${BLU}╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝╚═╝░░░░░╚═╝░╚═════╝░"
fi

echo -e "${YEL}\nConfigs\n${NC}"
#copia configs
apagar="$(ls -h config/)"
cd ../
sudo rm -rf $apagar
cd 4work/
ln -rsf config/* ../
#links em bin
sudo ln -rsf scripts/menus /bin/
#links em home
rm -f ~/.bashrc ~/.profile
ln -rsf home/.bashrc home/.profile ~/

if [ "${1:-}" = "-n" ]; then
	echo "Flag -n usada então não vai baixar nada"
	exit 1
else
	echo -e "${YEL}\nAtualizando...\n${NC}"
	sudo pacman -Syu $flags base-devel  
	echo -e "${YEL}\nBaixando Apps...\n${NC}"
	#Interface
	sudo pacman -S $flags hyprland quickshell qt6ct nwg-look polkit-kde-agent xdg-desktop-portal-hyprland hyprsunset 
	#Audio
	sudo pacman -S $flags gst-plugin-pipewire libpipewire pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse wireplumber
	#Apps
	sudo pacman -S $flags kitty pavucontrol blueman thunar thunar-media-tags-plugin thunar-shares-plugin thunar-volman ffmpegthumbnailer tumbler gvfs gparted grim slurp gvfs-smb smbclient
	#Texto
	sudo pacman -S $flags neovim mousepad zathura zathura-pdf-mupdf 
	#Midia
	sudo pacman -S $flags playerctl mpd mpc mpd-mpris rmpc mpv imv libheif libjpeg-turbo libpng libtiff dav1d ffmpeg openjpeg2 rav1e svt-av1
	#CLI
	sudo pacman -S $flags fastfetch btop awk less libnotify yt-dlp ffmpeg cliphist wl-clipboard unzip github-cli flatpak tesseract-data-eng jq
	#Fontes
	sudo pacman -S $flags ttf-nerd-fonts-symbols-mono ttf-terminus-nerd adobe-source-code-pro-fonts ttf-googlesanscode-nerd noto-fonts
fi
#MPD
mkdir -p ~/.local/state/mpd
sudo systemctl --user enable mpd --now
mpc update
