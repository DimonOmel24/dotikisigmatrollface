#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$REPO_DIR/config"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config.backup-$(date +%s)"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "[!] config folder not found!"
    exit 1
fi

echo "[*] Creating directories..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_DIR"

echo "[*] Installing dotfiles..."

for item in "$DOTFILES_DIR"/*; do
    name=$(basename "$item")
    target="$CONFIG_DIR/$name"

    echo "[*] $name"

    # если уже есть — делаем бэкап
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "    -> backing up"
        mv "$target" "$BACKUP_DIR/"
    fi

    # создаём симлинк
    ln -s "$item" "$target"
done

read -p "[?] Install packages? (y/n): " choice

if [[ "$choice" == "y" ]]; then
    sudo pacman -S --needed hyprland kitty rofi starship fastfetch cava
fi

echo "[✓] Done!"
echo "[i] Backup: $BACKUP_DIR"
