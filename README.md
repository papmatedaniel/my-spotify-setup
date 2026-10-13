# My Spotify Setup (Cross-Platform)

Egyénileg konfigurált, letisztult Spicetify környezet Linuxra és Windowsra:
- **Reklámblokkoló:** Automatikus háttérbeli adblock (`adblock.js`).
- **Lyrics Plus (módosított):**
  - Borítókép és felesleges bal oldali margók nélkül.
  - Teljes képernyős szélesség, középre zárt szövegfolyam.
  - Natív Spotify-stílusú szabad egérgörgetés (`scrollIntoView`).
  - Nincs elhomályosítás (blur): a teljes dalszöveg éles és olvasható.
  - Többszörös fallback dalszövegforrások (LRCLIB, Netease, Genius, Spotify API).

---

## Telepítés Linuxon (Debian / Ubuntu / Linux Mint)

Futtasd a terminálban:

```bash
git clone https://github.com/papmatedaniel/my-spotify-setup.git
cd my-spotify-setup
bash install.sh
```

---

## Telepítés Windowson

> **Előfeltétel:** A Microsoft Store-ból letöltött Spotify a rendszer védelmi mechanizmusai (sandbox) miatt nem módosítható. Ha onnan van telepítve, távolítsd el, és telepítsd a hivatalos hagyományos klienst: [spotify.com/download/windows](https://www.spotify.com/download/windows/).

Nyiss egy **PowerShell** ablakot, és futtasd:

```powershell
git clone https://github.com/papmatedaniel/my-spotify-setup.git
cd my-spotify-setup
powershell -ExecutionPolicy Bypass -File .\install.ps1
```