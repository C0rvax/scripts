#!/bin/bash

# Dossier source
SOURCE_DIR="app/services/users"

# Dossier de sortie (où tu veux recopier les fichiers avec les chemins en commentaire)
DEST_FILE="sortie.txt"

# Vide le fichier de destination s'il existe
> "$DEST_FILE"

# Parcourt tous les fichiers (non-dossiers) du dossier source
find "$SOURCE_DIR" -type f | while read -r file; do
  echo "# $file" >> "$DEST_FILE"       # Met le chemin du fichier en commentaire
  cat "$file" >> "$DEST_FILE"          # Ajoute le contenu du fichier
  echo -e "\n" >> "$DEST_FILE"         # Ajoute une ligne vide pour séparer les fichiers
done

