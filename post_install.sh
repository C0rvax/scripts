#!/bin/bash

# Code couleur
rouge='\e[1;31m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
vert='\e[1;32m'
neutre='\e[0;m'

# Vérification que le script n'est pas lancé directement avec sudo (le script contient déjà les sudos pour les actions lorsque c'est nécessaire)
if [ "$UID" -eq "0" ]; then
	echo -e "${rouge}Merci de ne pas lancer directement ce script avec les droits root : lancez le sans sudo , le mot de passe sera demandé dans le terminal lors de la 1ère action nécessitant le droit administrateur.${neutre}"
	exit
fi

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

# INSTALL OH MY ZSH

cd $HOME
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
