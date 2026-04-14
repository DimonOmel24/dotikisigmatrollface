#!/bin/bash

set -e

REPO_URL="https://github.com/altcornix/do.git"
TEMP_DIR="$HOME/.dotfiles-temp"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config.backup-$(date +%s)"

echo "[*] Starting installation..."
echo ""
echo "[*] Cloning repository..."

# удаляем старый temp если есть
rm -rf "$TEMP_DIR"

git clone "$REPO_URL" "$TEMP_DIR"

DOTFILES_DIR="$TEMP_DIR/config"

# проверка
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "[!] config folder not found!"
    exit 1
fi

echo "[*] Creating directories..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_DIR"

echo "[*] Installing dotfiles..."

for item in "$DOTFILES_DIR"/*; do
    [ -e "$item" ] || continue

    name=$(basename "$item")
    target="$CONFIG_DIR/$name"

    echo "[*] $name"

    # backup
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "    -> backing up"
        mv "$target" "$BACKUP_DIR/"
    fi

    # symlink
    ln -s "$item" "$target"
done

echo "[✓] Done!"
echo "[i] Backup: $BACKUP_DIR"
