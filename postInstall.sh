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

# INSTALL KDE CONFIG
setup_kde

# A ajouter :
# pipx install compiledb
# icon
# install zsh p10k oh my zsh nulle
# ledger live
# pref du terminal et de kde
#
