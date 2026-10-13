#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1. Spotify előkészítése és engedélyek..."
# Ha még nincs Spotify mappa vagy prefs, létrehozzuk, hogy a Spicetify ne dobjon hibát
mkdir -p "$HOME/.config/spotify"
touch "$HOME/.config/spotify/prefs"

# Jogosultságok megadása a Spotify könyvtárnak (ha szükséges)
if [ -d "/usr/share/spotify" ] && [ ! -w "/usr/share/spotify" ]; then
    echo "Spotify mappa írási jogainak beállítása (sudo jelszót kérhet)..."
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R
fi

echo "==> 2. Spicetify CLI ellenőrzése..."
if ! command -v spicetify &> /dev/null; then
    echo "Spicetify nincs telepítve, csendes automatikus letöltés..."
    # A yes n kikerüli az interaktív Marketplace kérdést
    yes n | curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    export PATH="$PATH:$HOME/.spicetify"
fi

echo "==> 3. Alap konfiguráció generálása..."
# Előre beállítjuk a prefs és spotify útvonalat, hogy soha ne legyen detektálási hiba
spicetify config prefs_path "$HOME/.config/spotify/prefs" || true
if [ -d "/usr/share/spotify" ]; then
    spicetify config spotify_path "/usr/share/spotify" || true
fi

echo "==> 4. Kiegészítők másolása a repóból..."
mkdir -p "$HOME/.config/spicetify/CustomApps"
mkdir -p "$HOME/.config/spicetify/Extensions"

cp -r "$SCRIPT_DIR/CustomApps/lyrics-plus" "$HOME/.config/spicetify/CustomApps/"
cp "$SCRIPT_DIR/Extensions/adblock.js" "$HOME/.config/spicetify/Extensions/"

echo "==> 5. Spicetify beállítások felülírása..."
spicetify config custom_apps lyrics-plus
spicetify config extensions adblock.js

echo "==> 6. Alkalmazás..."
spicetify backup apply || spicetify apply

echo "==> SIKER! A tiszta, reklámmentes, görgethető Spotify készen áll."
