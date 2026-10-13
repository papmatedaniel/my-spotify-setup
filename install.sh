#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1. Spicetify CLI ellenőrzése..."
if ! command -v spicetify &> /dev/null; then
    echo "Spicetify nincs telepítve, automatikus letöltés..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    export PATH="$PATH:$HOME/.spicetify"
fi

echo "==> 2. Kiegészítők másolása..."
mkdir -p "$HOME/.config/spicetify/CustomApps"
mkdir -p "$HOME/.config/spicetify/Extensions"

cp -r "$SCRIPT_DIR/CustomApps/lyrics-plus" "$HOME/.config/spicetify/CustomApps/"
cp "$SCRIPT_DIR/Extensions/adblock.js" "$HOME/.config/spicetify/Extensions/"

echo "==> 3. Spicetify konfiguráció beállítása..."
spicetify config custom_apps lyrics-plus
spicetify config extensions adblock.js

echo "==> 4. Mentés és alkalmazás..."
spicetify backup apply || spicetify apply

echo "==> Kész! A tiszta, reklámmentes, görgethető Spotify sikeresen beállítva."
