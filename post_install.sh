#!/bin/bash

# Code couleur
rouge='\e[1;31m'
jaune='\e[1;33m'
bleu='\e[1;34m'
violet='\e[1;35m'
vert='\e[1;32m'
neutre='\e[0;m'

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

# Vérification que le script n'est pas lancé directement avec sudo (le script contient déjà les sudos pour les actions lorsque c'est nécessaire)
if [ "$UID" -eq "0" ]; then
	echo -e "${rouge}Merci de ne pas lancer directement ce script avec les droits root : lancez le sans sudo , le mot de passe sera demandé dans le terminal lors de la 1ère action nécessitant le droit administrateur.${neutre}"
	exit
fi

# FUNCTIONS

function check_file
{
	if [ -f "${1}" ];then
		return 1
	else
		return 0
	fi
}

function check_directory
{
	if [ -d "${1}" ];then
		return 1
	else
		return 0
	fi
}

function check_package
{
	dpkg -s ${1} &> /dev/null

	if [ $? -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

function install_package
{
	check_package ${1}
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### Package ${1} is installed! ####"
	else
		echo -e "${jaune} **** Installing ${1} ****"
		get_package ${1}
	fi
}

function get_package {

sudo apt-get install -y ${1}

}

echo -e "${vert}"
echo "     ██████╗ ██████╗ ██████╗ ██╗   ██╗ █████╗ ██╗  ██╗"
echo "    ██╔════╝██╔═████╗██╔══██╗██║   ██║██╔══██╗╚██╗██╔╝"
echo "    ██║     ██║██╔██║██████╔╝██║   ██║███████║ ╚███╔╝"
echo "    ██║     ████╔╝██║██╔══██╗╚██╗ ██╔╝██╔══██║ ██╔██╗"
echo "    ╚██████╗╚██████╔╝██║  ██║ ╚████╔╝ ██║  ██║██╔╝ ██╗"
echo "     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "${neutre}"

# UPDATE

echo -e "${bleu}"
sudo apt-get update && sudo apt-get upgrade
echo -e "${neutre}"

for PKG in "${PKGS[@]}"; do
	install_package ${PKG}
	echo -e "${neutre}"
done

# INSTALL NVIM + CONFIG

cd $HOME
check_file $HOME/nvim.appimage
if [ "$?" -eq "1" ]; then
	echo -e "${vert} #### NeoVim is installed! ####${neutre}"
else
	echo -e "${jaune} **** Installing NeoVim ****${neutre}"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
fi

check_directory $HOME/.config/nvim
if [ "$?" -eq "1" ]; then
	echo -e "${vert} #### nvim config is installed! ####${neutre}"
else
	echo -e "${jaune} **** Installing nvim config ****${neutre}"
	git clone git@github.com:C0rvax/nvim.git $HOME/.config/nvim
fi

# INSTALL VERACRYPT

echo ""
check_package "veracrypt"
if [ "$?" -eq "1" ]; then
	echo -e "${vert} #### Package veracrypt is installed! ####${neutre}"
else
	echo -e "${jaune} **** Installing veracrypt ****${neutre}"
	sudo add-apt-repository ppa:unit193/encryption -y
	sudo apt-get update -y
	sudo apt-get install veracrypt -y
fi


# CLEANING

echo -e "${bleu}"
sudo apt-get autoclean -y && sudo apt-get autoremove -y
echo -e "${neutre}"

# INSTALL OH MY ZSH

cd $HOME
check_directory $HOME/.oh-my-zsh
if [ "$?" -eq "1" ]; then
	echo -e "${vert} #### Oh My Zsh is installed! ####${neutre}"
else
	echo -e "${jaune} **** Installing Oh My Zsh ****${neutre}"
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
