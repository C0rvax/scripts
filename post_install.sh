#!/bin/bash

	# UPDATE

sudo apt-get update && sudo apt-get upgrade

	# FUNCTIONS

function get_package {
	sudo apt-get install -y ${1}
}

	# LIST OF PACKAGES

PKGS=(

	# PACMAN
	'curl'
	'nala'
	# COMPILER
	'clang'
	'gcc'
	'make'
	# UTILS
	'gimp'
	'htop'
	'neofetch'
	'ufw'
	# TERM
	'terminator'
	# NVIM DEPEDENCIES
	'fd-find'
	'ripgrep'
	'python3'
	# APP
	'freecad'
	'libreoffice'
	# ZSH
	'zsh'
)

for PKG in "${PKGS[@]}"; do
	get_package ${PKG}
done

	# INSTALL NVIM + CONFIG

cd $HOME
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
git clone git@github.com:C0rvax/nvim.git $HOME/.config/nvim

	# INSTALL VERACRYPT

sudo add-apt-repository ppa:unit193/encryption -y
sudo apt-get update -y
sudo apt-get install veracrypt -y

	# CLEANING

sudo apt-get autoclean -y && sudo apt-get autoremove -y
