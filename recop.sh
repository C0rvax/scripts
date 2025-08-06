#!/bin/bash

usage() {
	cat <<EOF
Usage: $(basename "$0") [options] <source_directory> [destination_filename]

Concatenates all TEXT files from a specified source directory into a single
destination file, located in ~/log/.

Arguments:
  <source_directory>      	The directory to scan for text files.
  [destination_filename]  	The output filename (optional, default: output.txt).
                        	File will be saved in \$HOME/log/

Options:
  -i, --ignore <dir_name>	Exclude a directory by name. Can be used multiple times.
                        	(e.g., -i build -i dist or --ignore build,dist)
  -f, --file   <file>		Exclude a specific file by name. Can be used multiple times.
							(e.g., -f .env,config.json)
  -h, --help              	Display this help message.

Default ignored directories: .git, node_modules
Default ignored files: .gitignore, .gitattributes, .dockerignore
EOF
	exit 1
}

IGNORE_DIRS=('.git' 'node_modules')
IGNORE_FILES=('.gitignore' '.gitattributes' '.dockerignore')

while [[ "$#" -gt 0 ]]; do
	case "$1" in
	-i | --ignore)
		if [[ -n "$2" ]]; then
			IFS=',' read -r -a dir <<<"$2"
			IGNORE_DIRS+=("${dir[@]}")
			shift 2
		else
			echo "Error: --ignore requires a directory name." >&2
			exit 1
		fi
		;;
	-f | --file)
		if [[ -n "$2" ]]; then
			IFS=',' read -r -a file <<<"$2"
			IGNORE_FILES+=("${file[@]}")
			shift 2
		else
			echo "Error: --file requires a file name." >&2
			exit 1
		fi
		;;
	-h | --help)
		usage
		;;
	*)
		break
		;;
	esac
done

SOURCE_DIR="$1"
DEST_FILENAME="${2:-output.txt}"
DEST_FILE="$HOME/log/$DEST_FILENAME"

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source directory '$SOURCE_DIR' does not exist or is not a directory." >&2
	exit 1
fi

mkdir -p "$HOME/log"
>"$DEST_FILE"

echo "Starting to concatenate text files from '$SOURCE_DIR' into '$DEST_FILE'"

PRUNE_ARGS=()
if [ ${#IGNORE_DIRS[@]} -gt 0 ]; then
	PRUNE_ARGS+=("(")
	PRUNE_ARGS+=("-path" "*/${IGNORE_DIRS[0]}")
	for dir in "${IGNORE_DIRS[@]:1}"; do
		PRUNE_ARGS+=("-o" "-path" "*/$dir")
	done
	PRUNE_ARGS+=(")")
	PRUNE_ARGS+=("-prune")
fi

NAME_ARGS=()
for file in "${IGNORE_FILES[@]}"; do
	NAME_ARGS+=("-not" "-name" "$file")
done

find "$SOURCE_DIR" \
	"${PRUNE_ARGS[@]}" -o -type f "${NAME_ARGS[@]}" -print0 | while IFS= read -r -d '' file; do

	MIME_TYPE=$(file --mime-type -b "$file")

	if [[ "$MIME_TYPE" == text/* ]]; then
		echo "#####################################################" >>"$DEST_FILE"
		echo "# $file" >>"$DEST_FILE"
		echo "#####################################################" >>"$DEST_FILE"
		cat "$file" >>"$DEST_FILE"
		echo -e "\n" >>"$DEST_FILE"
	fi
done

echo "Concatenation complete. Output saved to '$DEST_FILE'."
