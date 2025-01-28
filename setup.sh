#!/bin/bash

# Hyprland Rice Setup Script for Arch Linux

# Exit on any error
set -e

# Check if script is run with sudo/root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root" 
   exit 1
fi

# Update system packages first
echo "Updating system packages..."
pacman -Syu --noconfirm

# Install base-devel if not already installed (required for yay)
pacman -S --needed --noconfirm base-devel

# Install iniparser via pacman
echo "Installing iniparser..."
pacman -S --noconfirm iniparser

# Install yay (AUR helper)
echo "Installing yay AUR helper..."
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install packages using yay
echo "Installing waybar-cava, fftw, and cava..."
yay -S --noconfirm waybar-cava fftw cava

# Install packages using pacman
echo "Installing zsh, hyprlock, swww, kitty, and fastfetch..."
pacman -S --noconfirm zsh hyprlock swww kitty fastfetch

# Install hyprshot via yay
echo "Installing hyprshot..."
yay -S --noconfirm hyprshot

# Install rofi-wayland
echo "Installing rofi-wayland..."
yay -S --noconfirm rofi-wayland

# Sets up fonts
echo "Setting up fonts..."
mv fonts/* /usr/share/fonts/
fc-cache -fv

# Installs Neovim & NVChad
echo "Installing Neovim & NVChad..."
yay -S --noconfirm neovim nvchad

# Installs nwg-look
echo "Installing nwg-look..."
yay -S --noconfirm nwg-look

cp -r ./fastfetch ./hypr ./kitty ./rofi ./waybar -t ~/.config
cp -r ./icons/* -t -r /usr/share/icons/

cp -r ./gtktheme/* -r -t /usr/share/themes/
cp -r ./.zshrc ./.p10k.zsh -t ~/
swww init &> /dev/null
swww img ~/.config/hypr/wallpaper.jpg &> /dev/null
killall waybar &> /dev/null
waybar &> /dev/null
cd ..
hyprctl setcursor hypr-dots 24

echo "Installation complete! Enjoy your new Hyprland rice!"
