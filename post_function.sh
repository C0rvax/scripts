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
		echo -e "${vert} #### Package ${1} is installed! ####"
	else
		echo -e "${jaune} **** Installing ${1} ****"
		get_package ${1}
	fi
}

function get_package {

	sudo apt-get install -y ${1}

}

# Check if launched with sudo
function check_sudo {
	if [ "$UID" -eq "0" ]; then
		echo -e "${rouge}Do not execute with sudo, Your password will be asked in the console.${neutre}"
		exit
	fi
}

# Update
function p_update {
	echo -e "${bleu}"
	sudo apt-get update -y && sudo apt-get upgrade -y
	echo -e "${neutre}"
}

# Clean
function p_clean {
	echo -e "${bleu}"
	sudo apt-get autoclean -y && sudo apt-get autoremove -y
	echo -e "${neutre}"
}
