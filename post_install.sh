#!/bin/bash

source post_function.sh
source post_spec.sh
source post_list

check_sudo

echo -e "${vert}"
echo "     ██████╗ ██████╗ ██████╗ ██╗   ██╗ █████╗ ██╗  ██╗"
echo "    ██╔════╝██╔═████╗██╔══██╗██║   ██║██╔══██╗╚██╗██╔╝"
echo "    ██║     ██║██╔██║██████╔╝██║   ██║███████║ ╚███╔╝"
echo "    ██║     ████╔╝██║██╔══██╗╚██╗ ██╔╝██╔══██║ ██╔██╗"
echo "    ╚██████╗╚██████╔╝██║  ██║ ╚████╔╝ ██║  ██║██╔╝ ██╗"
echo "     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "${neutre}"

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
