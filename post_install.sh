#!/bin/bash

# Mandatory

sudo apt-get update && sudo apt-get upgrade

function get_package {
	sudo apt-get install -y ${1}
}
PKGS=(

	# PACMAN
	'curl'
	'nala'
	# COMPILER
	'clang'
	'gcc'
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
