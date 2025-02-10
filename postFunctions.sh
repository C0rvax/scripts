# SET GIT GLOBAL CONFIG
function install_git {
	echo -e "${BLUEHI} ---- GIT global config ----"
	read -p "Do You want to set git user and email ? [y/n]" rep
	case $rep in
	Y)
		read -p 'Git username: ' gituser
		read -p 'Git email: ' gitemail
		git config --global user.name "$gituser"
		git config --global user.email $gitemail
		echo -e "${RESET}"
		;;
	y)
		read -p 'Git username: ' gituser
		read -p 'Git email: ' gitemail
		git config --global user.name "$gituser"
		git config --global user.email $gitemail
		echo -e "${RESET}"
		;;
	N)
		echo " ---- Skipping ----"
		echo -e "${RESET}"
		;;
	n)
		echo " ---- Skipping ----"
		echo -e "${RESET}"
		;;
	esac
}

# INSTALL NVIM + CONFIG
function install_nvim {
	cd $HOME
	check_file $HOME/AppImage/nvim.appimage
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### NeoVim is installed! ####${RESET}"
	else
		check_directory $HOME/AppImage
		if [ "$?" -eq "1" ]; then
			echo -e "${BLUEHI} **** Installing NeoVim ****${YELLOW}"
		else
			mkdir AppImage
		fi
		cd $HOME/AppImage
		wget -O nvim-appimage https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
		chmod u+x nvim.appimage
		cd $HOME
		echo -e "${RESET}"
	fi

	check_directory $HOME/.config/nvim
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### nvim config is installed! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Installing nvim config ****${YELLOW}"
		git clone https://github.com/C0rvax/nvim.git $HOME/.config/nvim
	fi
}

# INSTALL VERACRYPT
function install_veracrypt {
	echo ""
	check_package "veracrypt"
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Package veracrypt is installed! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Installing veracrypt ****${YELLOW}"
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
		echo -e "${GREENHI} #### Oh My Zsh is installed! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Installing Oh My Zsh ****${YELLOW}"
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
	echo ""
}

# INSTALL FONTS
function install_fonts {
	check_directory $HOME/Themes
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Folder Themes already exist! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Creating folder ****${YELLOW}"
		mkdir $HOME/Themes
	fi
	check_directory $HOME/Themes/Fonts
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Folder Fonts already exist! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Creating folder ****${YELLOW}"
		mkdir -p $HOME/Themes/Fonts
	fi
	check_file $HOME/Themes/Fonts/'MesloLGS NF Regular.ttf'
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Fonts is installed! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Installing fonts ****${YELLOW}"
		curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/Themes/Fonts/'MesloLGS NF Regular.ttf'
		curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/Themes/Fonts/'MesloLGS NF Bold.ttf'
		curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/Themes/Fonts/'MesloLGS NF Italic.ttf'
		curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/Themes/Fonts/'MesloLGS NF Bold Italic.ttf'
	fi
	check_directory $HOME/Themes/Icons
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Folder Icons already exist! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Creating folder ****${YELLOW}"
		mkdir $HOME/Themes/Icons
	fi
	check_directory $HOME/Themes/Icons/buuf-nestort
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### buuf-nestort already exist! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Downloading Pack ****${YELLOW}"
		git clone https://git.disroot.org/eudaimon/buuf-nestort.git ~/Themes/Icons/buuf-nestort
		sudo ln -s ~/Themes/Icons/buuf-nestort /usr/share/icons/buuf-nestort
	fi
}

# INSTALL ZSH CONFIG
function install_zconfig {
	cd $HOME
	check_directory $HOME/.zsh
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Zsh config is installed! ####${RESET}"
	else
		echo -e "${BLUEHI} **** Installing Zsh config ****${YELLOW}"
		git clone https://github.com/C0rvax/.zsh.git $HOME/.zsh
		bash .zsh/install_zshrc.sh
	fi
	sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
	echo -e "${RESET}"
}

# SET KDE CONFIG
function setup_kde {
	# Vérifier si l'environnement est KDE Plasma
	if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] || [[ "$DESKTOP_SESSION" == "plasma" ]] || qdbus org.kde.PlasmaShell >/dev/null 2>&1; then
		# Modifier la police du système
		kwriteconfig5 --file kdeglobals --group General --key fixed "MesloLGS NF,9,-1,5,50,0,0,0,0,0"
		kwriteconfig5 --file kdeglobals --group General --key font "MesloLGS NF,10,-1,5,50,0,0,0,0,0,Regular"
		kwriteconfig5 --file kdeglobals --group General --key menuFont "MesloLGS NF,10,-1,5,50,0,0,0,0,0,Regular"
		kwriteconfig5 --file kdeglobals --group General --key smallestReadableFont "MesloLGS NF,8,-1,5,50,0,0,0,0,0,Regular"
		kwriteconfig5 --file kdeglobals --group General --key toolBarFont "MesloLGS NF,10,-1,5,50,0,0,0,0,0,Regular"
		kwriteconfig5 --file kdeglobals --group WM --key activeFont "MesloLGS NF,10,-1,5,50,0,0,0,0,0"

		# Modifier teminal par défaut
		kwriteconfig5 --file kdeglobals --group General --key TerminalApplication "terminator"
		kwriteconfig5 --file kdeglobals --group General --key TerminalService "terminator.desktop"

		# Activer les Icones
		kwriteconfig5 --file kdeglobals --group Icons --key Theme "buuf-nestort"

		# Activer le thème Breeze sombre
		lookandfeeltool -a org.kde.breezedark.desktop

		# Config de KFileDialiog
		kwriteconfig5 --file kdeglobals --group "KFileDialog Settings" --key "Sort directories first" true
		kwriteconfig5 --file kdeglobals --group "KFileDialog Settings" --key "Show hidden files" true
		kwriteconfig5 --file kdeglobals --group "KFileDialog Settings" --key "Sort hidden files last" true
		kwriteconfig5 --file kdeglobals --group "KFileDialog Settings" --key "View Style" "DetailTree"

		# Configurer un simple clic pour ouvrir les fichiers
		kwriteconfig5 --file kdeglobals --group KDE --key SingleClick false

		kwriteconfig5 --file kiorc --group Confirmations --key ConfirmDelete false
		kwriteconfig5 --file kiorc --group Confirmations --key ConfirmEmptyTrash false
		kwriteconfig5 --file kiorc --group Confirmations --key ConfirmTrash false

		# Appliquer les changements
		qdbus org.kde.KWin /KWin reconfigure
	fi
}

# FUNCTIONS
function check_file {
	if [ -f "${1}" ]; then
		return 1
	else
		return 0
	fi
}

function check_directory {
	if [ -d "${1}" ]; then
		return 1
	else
		return 0
	fi
}

function check_package {
	dpkg -s ${1} &>/dev/null

	if [ $? -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

function install_package {
	check_package ${1}
	if [ "$?" -eq "1" ]; then
		echo -e "${GREENHI} #### Package ${1} is installed! ####"
	else
		echo -e "${BLUEHI} **** Installing ${1} ****${YELLOW}"
		get_package ${1}
	fi
}

function get_package {

	sudo apt-get install -y ${1}

}

# Check if launched with sudo
function check_sudo {
	if [ "$UID" -eq "0" ]; then
		echo -e "${REDHI}Do not execute with sudo, Your password will be asked in the console.${RESET}"
		exit
	fi
}

# Update
function p_update {
	echo -e "${BLUEHI}"
	sudo apt-get update -y && sudo apt-get upgrade -y
	echo -e "${RESET}"
}

# Clean
function p_clean {
	echo -e "${BLUEHI}"
	sudo apt-get autoclean -y && sudo apt-get autoremove -y
	echo -e "${RESET}"
}

# Display logo
function display_logo {
	echo -e "${GREENHI}"
	echo "   ██████╗ ██████╗ ██████╗ ██╗   ██╗ █████╗ ██╗  ██╗"
	echo "  ██╔════╝██╔═████╗██╔══██╗██║   ██║██╔══██╗╚██╗██╔╝"
	echo "  ██║     ██║██╔██║██████╔╝██║   ██║███████║ ╚███╔╝"
	echo "  ██║     ████╔╝██║██╔══██╗╚██╗ ██╔╝██╔══██║ ██╔██╗"
	echo "  ╚██████╗╚██████╔╝██║  ██║ ╚████╔╝ ██║  ██║██╔╝ ██╗"
	echo "   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝"
	echo -e "${BLUEHI}"

	echo "         ██████╗  ██████╗ ███████╗████████╗"
	echo "         ██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝"
	echo "         ██████╔╝██║   ██║███████╗   ██║   "
	echo "         ██╔═══╝ ██║   ██║╚════██║   ██║   "
	echo "         ██║     ╚██████╔╝███████║   ██║   "
	echo "         ╚═╝      ╚═════╝ ╚══════╝   ╚═╝   "
	echo ""
	echo "██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     "
	echo "██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     "
	echo "██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     "
	echo "██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     "
	echo "██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗"
	echo "╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝"
	echo -e "${RESET}"
}
