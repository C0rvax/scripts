#!/bin/bash

source postList
source postFunctions.sh

detect_distro
detect_desktop

display_logo

check_sudo

p_update

# INSTALL PACKAGES

for PKG in "${PKGS[@]}"; do
	install_package ${PKG}
	echo -e "${neutre}"
done

p_update

# INSTALL SPEC

install_git

install_nvim

install_veracrypt

install_fonts

# CLEANING

p_clean

# INSTALL OH MY ZSH

install_zsh

# INSTALL ZSH CONFIG

install_zconfig

p_update

# INSTALL DESKTOP CONFIG
if [[ "$DESKTOP" == "kde" ]]; then
	setup_kde
elif [[ "$DESKTOP" == "gnome" ]]; then
	setup_gnome
elif [[ "$DESKTOP" == "xfce" ]]; then
	setup_xfce
elif [[ "$DESKTOP" == "lxde" ]]; then
	setup_lxde
elif [[ "$DESKTOP" == "lxqt" ]]; then
	setup_lxqt
elif [[ "$DESKTOP" == "mate" ]]; then
	setup_mate
elif [[ "$DESKTOP" == "cinnamon" ]]; then
	setup_cinnamon
fi

setup_vlc

p_update
p_clean

# A AJOUTER
# ssh key
# icon fix
# driver nvidia sudo apt install nvidia-driver-550
# raccourcis
# tableau de bord
# pipx install compiledb
# ledger live
