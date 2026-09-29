# DHAROHAR 1.0 — WEB DEPLOYMENT & HOSTING GUIDE

This document provides complete instructions for exporting, testing, embedding, and hosting **Dharohar 1.0** on modern web browsers and websites.

---

## 1. Overview of Web Features

- **Universal Browser Compatibility**: Runs on Google Chrome, Microsoft Edge, Mozilla Firefox, Apple Safari, and Chromium browsers.
- **Renderer**: `gl_compatibility` (WebGL 2.0) for stable 2D pixel-art rendering.
- **Resolution**: 1152 × 648 base logical resolution with proportional aspect-ratio scaling (no stretching, squashing, or cropping).
- **Custom Indian Heritage Branding**: Completely removes Godot engine splash/branding. Features a custom Nalanda diya emblem, golden typography, and animated manuscript loading progress bar.
- **Persistent Save System**: Multi-layer persistent storage (`user://dharohar_save.json` via IndexedDB and `localStorage` mirror) automatically preserving scholar names, domain choices, EXP/levels, scrolls, quests, and mastery completion.
- **Audio Autoplay Resilience**: Seamlessly starts background music and sound effects upon the player's first interaction.
- **Fullscreen & Focus Integration**: Direct fullscreen button and automatic input focus management.

---

## 2. Directory Structure of Web Build

Exported files are located in `/exports/web/`:

```
dharohar-1.0/
├── exports/
│   └── web/
│       ├── index.html                  # Custom Nalanda Heritage HTML Shell & Loading presentation
│       ├── index.js                    # Godot Web runtime bridge
│       ├── index.wasm                  # WebAssembly game binary
│       ├── index.pck                   # Game assets pack (scenes, sprites, audio, data)
│       ├── index.audio.worklet.js      # Web Audio processor worklet
│       ├── index.audio.position.worklet.js
│       ├── index.icon.png              # Favicon / web app icon
│       ├── index.png                   # Custom splash texture
│       └── index.apple-touch-icon.png  # Apple touch icon
```

---

## 3. How to Export

### Option A: Via Command Line (Recommended / Automated)
From the project root directory, run:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --export-release "Dharohar Web" exports/web/index.html
```

### Option B: Via Godot Editor UI
1. Open the project in Godot 4.
2. Go to **Project** -> **Export...**.
3. Select the **Dharohar Web** preset.
4. Click **Export Project...**.
5. Save the output to `exports/web/index.html`.

---

## 4. How to Test Locally

Browsers restrict WebAssembly and Web Audio when opened directly via `file://`. Always test through a local HTTP server:

### Run the Included Local Server:
From the project root:
```bash
python scripts/serve_web.py 8000
```
Open **[http://localhost:8000](http://localhost:8000)** in your browser.

*(Or run any static HTTP server such as `npx serve exports/web` or `python -m http.server 8000 --directory exports/web`).*

---

## 5. Website Embedding Examples

### A. Responsive `<iframe>` Embed (For Blogs / Portals / CMS)
Embed the game into any container on your existing website:

```html
<div style="position: relative; width: 100%; max-width: 1152px; aspect-ratio: 16 / 9; margin: 0 auto; box-shadow: 0 10px 30px rgba(0,0,0,0.8); border: 2px solid #b88628; border-radius: 8px; overflow: hidden;">
    <iframe 
        src="https://your-domain.com/dharohar/index.html" 
        style="width: 100%; height: 100%; border: none;" 
        allow="fullscreen; autoplay" 
        allowfullscreen>
    </iframe>
</div>
```

### B. Direct Web Page Embed (Full Screen / Standalone)
Upload the contents of `exports/web/` directly to your web server root or subfolder (e.g. `https://your-domain.com/play/`).

---

## 6. Web Server & Hosting Configuration

### Required MIME Types:
Ensure your web server (Apache, Nginx, Cloudflare, etc.) serves the following MIME types:
- `.wasm` -> `application/wasm`
- `.pck` -> `application/octet-stream`
- `.js` -> `application/javascript`
- `.html` -> `text/html`

### Hosting Platforms:
- **GitHub Pages**: Upload `exports/web/` contents to `gh-pages` branch or `/docs` folder.
- **Netlify / Vercel**: Set publish directory to `exports/web`.
- **itch.io**: Zip the files inside `exports/web/` and upload as an HTML5 game.

---

## 7. Controls & Browser Interactions

| Control | Action |
| :--- | :--- |
| **W, A, S, D / Arrow Keys** | Move Scholar |
| **E** | Interact with NPCs, Monuments, and Portals |
| **I / i** | Inspect Monument / Building Knowledge |
| **ESC / Pause** | Pause Menu / Back |
| **278007** (Key Sequence) | Developer Mode Toggle |
| **TAB** | Developer Jump Menu (when Dev Mode is active) |

### Audio Autoplay Notice:
Modern browsers require at least one user click or keypress before allowing audio playback. A subtle guide prompt informs players to click anywhere on the canvas to begin audio and gameplay.

---

## 8. Save Game Persistence

- **Dual-layer Persistence**: Game progress automatically saves to Godot's virtual filesystem (`user://dharohar_save.json` backed by browser IndexedDB) and mirrors to `window.localStorage`.
- **Saved State Details**:
  - Scholar Name & Profile
  - Selected Study Domain (Mathematics, Astronomy, Medicine, Philosophy)
  - Teacher 1 & Gatekeeper admissions and quiz ratings
  - Side quest progress, manuscript deliveries, and collected provisions
  - Stupa, Library, and Vihara building trials, difficulty tiers, and earned scrolls
  - 3-Level Masteries across all 4 learning domains
  - Player EXP, Level, and Nalanda completion reward status
- **Clearing Data**: Calling `GameState.clear_saved_game()` clears both IndexedDB and localStorage data.
