#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1. Könyvtárak és futtatási jogok előkészítése..."
mkdir -p "$HOME/.config/spotify"
touch "$HOME/.config/spotify/prefs"

if [ -d "/usr/share/spotify" ] && [ ! -w "/usr/share/spotify" ]; then
    echo "Spotify mappa írási jogainak megadása (sudo szükséges lehet)..."
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R
fi

echo "==> 2. Spicetify CLI telepítése / ellenőrzése..."
if ! command -v spicetify &> /dev/null; then
    mkdir -p "$HOME/.spicetify"
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh -s -- --no-marketplace
fi
export PATH="$PATH:$HOME/.spicetify"

echo "==> 3. Alap konfiguráció ellenőrzése..."
spicetify config prefs_path "$HOME/.config/spotify/prefs" || true
if [ -d "/usr/share/spotify" ]; then
    spicetify config spotify_path "/usr/share/spotify" || true
fi

echo "==> 4. Kiegészítők másolása a repóból..."
mkdir -p "$HOME/.config/spicetify/CustomApps"
mkdir -p "$HOME/.config/spicetify/Extensions"

cp -r "$SCRIPT_DIR/CustomApps/lyrics-plus" "$HOME/.config/spicetify/CustomApps/"
cp "$SCRIPT_DIR/Extensions/adblock.js" "$HOME/.config/spicetify/Extensions/"

echo "==> 5. Beállítások aktiválása..."
spicetify config custom_apps lyrics-plus
spicetify config extensions adblock.js

echo "==> 6. Friss mentés készítése és alkalmazás..."
spicetify backup apply

echo "==> KÉSZ! A Spicetify, a görgethető Lyrics Plus és az Adblock sikeresen telepítve."
