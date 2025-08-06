#!/bin/bash

# Script pour sauvegarder la configuration Neovim (~/.config/nvim)
# et les plugins lazy (~/.local/share/nvim/lazy).

BACKUP_ROOT="$HOME/nvim_backup"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d_%H%M%S)"

if [ -d "$BACKUP_DIR" ]; then
	echo "Erreur : Le répertoire de sauvegarde '$BACKUP_DIR' existe déjà."
	exit 1
fi

echo "Création de la sauvegarde dans : $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "Copie de la configuration ~/.config/nvim ..."
# L'option -a préserve les permissions, -v pour verbose, -h pour lisible par l'homme
rsync -avh --progress "$HOME/.config/nvim/" "$BACKUP_DIR/config"

echo "Copie des plugins ~/.local/share/nvim/lazy ..."
rsync -avh --progress "$HOME/.local/share/nvim/lazy/" "$BACKUP_DIR/lazy_plugins"

echo ""
echo "✅ Sauvegarde terminée avec succès !"
