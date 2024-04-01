# SET GIT GLOBAL CONFIG
function install_git {
	echo -e "${violet} ---- GIT global config ----"
	read -p "Do You want to set git user and email ? [y/n]" rep
	case $rep in
	Y)
		read -p 'Git username: ' gituser
		read -p 'Git email: ' gitemail
		git config --global user.name "$gituser"
		git config --global user.email $gitemail
		echo -e "${neutre}"
		;;
	y)
		read -p 'Git username: ' gituser
		read -p 'Git email: ' gitemail
		git config --global user.name "$gituser"
		git config --global user.email $gitemail
		echo -e "${neutre}"
		;;
	N)
		echo " ---- Skipping ----"
		echo -e "${neutre}"
		;;
	n)
		echo " ---- Skipping ----"
		echo -e "${neutre}"
		;;
	esac
}

# INSTALL NVIM + CONFIG
function install_nvim {
	cd $HOME
	check_file $HOME/AppImage/nvim.appimage
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### NeoVim is installed! ####${neutre}"
	else
		echo -e "${jaune} **** Installing NeoVim ****"
		cd $HOME/AppImage
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x nvim.appimage
		cd $HOME
		echo -e "${neutre}"
	fi

	check_directory $HOME/.config/nvim
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### nvim config is installed! ####${neutre}"
	else
		echo -e "${jaune} **** Installing nvim config ****"
		git clone git@github.com:C0rvax/nvim.git $HOME/.config/nvim
	fi
}

# INSTALL VERACRYPT
function install_veracrypt {
	echo ""
	check_package "veracrypt"
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### Package veracrypt is installed! ####${neutre}"
	else
		echo -e "${jaune} **** Installing veracrypt ****"
		sudo add-apt-repository ppa:unit193/encryption -y
		sudo apt-get update -y
		sudo apt-get install veracrypt -y
	fi
}

# INSTALL OH MY ZSH
function install_zsh {
	cd $HOME
	check_directory $HOME/.oh-my-zsh
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### Oh My Zsh is installed! ####${neutre}"
	else
		echo -e "${jaune} **** Installing Oh My Zsh ****"
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
	echo ""
}

# INSTALL FONTS
function install_fonts {
	check_directory $HOME/.fonts
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### Folder ./fonts already exist! ####${neutre}"
	else
		echo -e "${jaune} **** Creating folder ****"
		mkdir -p $HOME/.fonts
		check_file $HOME/.fonts/'MesloLGS NF Regular.ttf'
		if [ "$?" -eq "1" ]; then
			echo -e "${vert} #### Fonts is installed! ####"
		else
			echo -e "${jaune} **** Installing fonts ****"
			curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/.fonts/'MesloLGS NF Regular.ttf'
			curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/.fonts/'MesloLGS NF Bold.ttf'
			curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/.fonts/'MesloLGS NF Italic.ttf'
			curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/.fonts/'MesloLGS NF Bold Italic.ttf'
		fi
	fi
}

# INSTALL ZSH CONFIG
function install_zconfig {
	cd $HOME
	check_directory $HOME/.zsh
	if [ "$?" -eq "1" ]; then
		echo -e "${vert} #### Zsh config is installed! ####${neutre}"
	else
		echo -e "${jaune} **** Installing Zsh config ****"
		git clone git@github.com:C0rvax/.zsh.git $HOME/.zsh
	fi
	git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
	echo -e "${neutre}"
}
