#!/bin/bash

# Script pour restaurer la DERNIÈRE sauvegarde Neovim créée par savimrc.sh

BACKUP_ROOT="$HOME/nvim_backup"

echo "Recherche de la dernière sauvegarde dans $BACKUP_ROOT..."
LATEST_BACKUP=$(ls -1 "$BACKUP_ROOT" | sort -r | head -n 1)

if [ -z "$LATEST_BACKUP" ]; then
	echo "Erreur : Aucun répertoire de sauvegarde trouvé dans $BACKUP_ROOT."
	echo "Veuillez d'abord créer une sauvegarde avec le script 'savimrc.sh'."
	exit 1
fi

BACKUP_TO_RESTORE="$BACKUP_ROOT/$LATEST_BACKUP"
echo "Dernière sauvegarde trouvée : $LATEST_BACKUP"

read -p "Voulez-vous restaurer cette version ? Votre configuration actuelle sera déplacée. (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Restauration annulée."
	exit 0
fi

echo "Mise de côté de la configuration actuelle..."
CURRENT_CONFIG="$HOME/.config/nvim"
CURRENT_SHARE="$HOME/.local/share/nvim"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -d "$CURRENT_CONFIG" ]; then
	mv "$CURRENT_CONFIG" "${CURRENT_CONFIG}.before-restore-${TIMESTAMP}"
	echo " -> Configuration actuelle déplacée vers : ${CURRENT_CONFIG}.before-restore-${TIMESTAMP}"
fi
if [ -d "$CURRENT_SHARE" ]; then
	mv "$CURRENT_SHARE" "${CURRENT_SHARE}.before-restore-${TIMESTAMP}"
	echo " -> Données actuelles déplacées vers : ${CURRENT_SHARE}.before-restore-${TIMESTAMP}"
fi

echo "Restauration depuis '$LATEST_BACKUP'..."

echo "Restauration de la configuration..."
mkdir -p "$CURRENT_CONFIG"
rsync -avh --progress "$BACKUP_TO_RESTORE/config/" "$CURRENT_CONFIG"

echo "Restauration des plugins..."
mkdir -p "$CURRENT_SHARE/lazy"
rsync -avh --progress "$BACKUP_TO_RESTORE/lazy_plugins/" "$CURRENT_SHARE/lazy"

echo ""
echo "✅ Restauration terminée avec succès !"
echo "Lancez 'nvim' pour vérifier."
echo "Si tout est OK, vous pourrez supprimer les dossiers '.before-restore-${TIMESTAMP}'."
