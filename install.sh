#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1. Könyvtárak és írási jogok biztosítása..."
mkdir -p "$HOME/.config/spotify"
touch "$HOME/.config/spotify/prefs"

if [ -d "/usr/share/spotify" ] && [ ! -w "/usr/share/spotify" ]; then
    echo "Spotify mappa írási jogainak megadása (sudo)..."
    sudo chmod a+wr /usr/share/spotify
    sudo chmod a+wr /usr/share/spotify/Apps -R
fi

echo "==> 2. Spicetify CLI csendes telepítése..."
if ! command -v spicetify &> /dev/null; then
    # Letöltjük és levágjuk a Marketplace promptot, így kérdés nélkül települ a CLI
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sed '/Do you want to install spicetify Marketplace/,$d' | sh
fi
export PATH="$PATH:$HOME/.spicetify"

echo "==> 3. Alap útvonalak konfigurálása..."
spicetify config prefs_path "$HOME/.config/spotify/prefs" || true
if [ -d "/usr/share/spotify" ]; then
    spicetify config spotify_path "/usr/share/spotify" || true
fi

echo "==> 4. Kiegészítők bemásolása a repóból..."
mkdir -p "$HOME/.config/spicetify/CustomApps"
mkdir -p "$HOME/.config/spicetify/Extensions"

cp -r "$SCRIPT_DIR/CustomApps/lyrics-plus" "$HOME/.config/spicetify/CustomApps/"
cp "$SCRIPT_DIR/Extensions/adblock.js" "$HOME/.config/spicetify/Extensions/"

echo "==> 5. Beállítások aktiválása..."
spicetify config custom_apps lyrics-plus
spicetify config extensions adblock.js

echo "==> 6. Tiszta mentés és injektálás..."
# Ha frissült a Spotify, a restore backup apply szükséges; ha szűz, a backup apply
spicetify restore backup apply 2>/dev/null || spicetify backup apply

echo "==> SIKER! A tiszta Spicetify, a görgethető Lyrics Plus és az Adblock sikeresen telepítve."
