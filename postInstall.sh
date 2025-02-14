#!/bin/bash

source postList
source postFunctions.sh

#get_home_dir

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

# INSTALL KDE CONFIG
setup_kde

# A AJOUTER
# ssh key
# icon fix
# driver nvidia sudo apt install nvidia-driver-550
# raccourcis
# tableau de bord
# pipx install compiledb
# ledger live
