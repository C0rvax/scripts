#!/bin/bash

set -e

BACKUP_DIR=~/nvim_backups/stable_$(date +%Y%m%d_%H%M%S)

echo "Création du backup dans : $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"

echo "Copie de la configuration..."
cp -r ~/.config/nvim "$BACKUP_DIR/config"

echo "Copie des plugins Lazy..."
cp -r ~/.local/share/nvim/lazy "$BACKUP_DIR/lazy_plugins"

echo "Backup terminé avec succès !"
