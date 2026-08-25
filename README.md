# Dharohar 1.0 — Ancient Indian Knowledge Systems

**Dharohar 1.0** is an immersive 2D educational RPG built with Godot Engine 4.x, designed to celebrate and preserve ancient Indian knowledge systems, culture, and heritage through interactive gameplay, domain-specific cutscenes, historical knowledge quizzes, and intellectual puzzle challenges set in the legendary **Nalanda Mahavihara**.

---

## 🏛️ Why Dharohar? — Our Vision

India has one of the world's richest histories and cultural heritages, from ancient centres of learning like Nalanda to its remarkable traditions in mathematics, astronomy, medicine, philosophy, architecture, art, and literature.

However, for many young learners, history and heritage are often experienced mainly through textbooks, memorisation, and examinations. At the same time, the space given to India's history, heritage, and cultural knowledge in formal curricula has become more limited, leaving many students disconnected from the stories and achievements of their own civilisation.

**Dharohar is our attempt to bridge this gap.**

Instead of asking children to simply read about India's heritage, Dharohar allows them to **experience it**.

### 📜 Our Approach

Through a 2D interactive historical world, learners can:

- 🏛️ **Explore** historically inspired Indian heritage environments
- 📜 **Discover** stories behind monuments, buildings, manuscripts, and artefacts
- 👨‍🏫 **Learn** from in-game scholars and teachers
- 🧠 **Understand** India's intellectual traditions
- 🧩 **Apply** knowledge through domain-based puzzles and challenges
- 🌏 **Discover** how Indian knowledge travelled across regions and cultures

For our first experience, we focus on **Nalanda Mahavihara** — transforming it from something a learner may only encounter as a name in a textbook into a world they can actually explore.

### ✨ What Makes Dharohar Different?

We don't want learning to feel like an examination.

Our philosophy is:
> **Explore → Discover → Learn → Think → Solve**

A student might first discover a library, learn about manuscripts and knowledge preservation, meet a teacher who introduces mathematics or astronomy, and then apply that knowledge through an interactive challenge.

This creates a connection between **history and action**.

### 🌏 Our Larger Vision

Dharohar is not intended to remain just a Nalanda game.

Nalanda is our starting point for building a larger interactive heritage-learning platform where young learners can eventually explore different periods, regions, monuments, scholars, scientific achievements, traditions, and cultural stories from across India.

**Our goal is simple:**
> Make India's heritage something young learners don't just study — but **experience, question, remember, and take pride in**.

---

## 👥 Team Members

| S.No. | Team Member Name | Role / Contribution |
| :---: | :--- | :--- |
| 1 | **Prisha Saxena** | Core Team Member |
| 2 | **Pushpendra Kumar Verma** | Core Team Member |
| 3 | **Raj Kumar Rana** | Core Team Member |
| 4 | **Shiv Bharadwaj** | Core Team Member |
| 5 | **Pratham Agarwal** | Core Team Member |
| 6 | **Devansh Diwedi** | Core Team Member |

---

## 🌟 Key Features

1. **Nalanda Map Exploration**:
   - Detailed 2D pixel-art environmental maps of ancient Nalanda and the Nalanda University complex.
   - Dynamic NPC interaction system (Merchant, Teacher Silabhadra, Disciples).
   - Building Information Triggers (`[i]` prompt) detailing the history, architecture, and significance of ancient stupas and structures.

2. **Cinematic Cutscene System**:
   - **Video 1 Intro Cutscene**: Plays dynamically upon first entering the Nalanda Map from the Experience Screen.
   - **Domain-Specific Travel Cutscenes**: Custom cutscene playback for **Mathematics** (Video 2) and **Astronomy** (Video 3) when travelling to Nalanda University.
   - Automatic natural video end detection and redirection, with an accessible `SKIP ▶` button.

3. **First-Time Player Controls Tutorial**:
   - One-time **"HOW TO PLAY"** popup appearing after the welcome message to guide new players.
   - Formatted using ancient Indian parchment/wood UI styling with clear key binding references.

4. **Domain Selection & Knowledge Quizzes**:
   - 5 core domain paths: **Mathematics**, **Astronomy**, **Medicine**, **Philosophy**, and **Logic**.
   - Merchant entrance knowledge quiz testing general awareness of Nalanda's history.
   - Teacher Silabhadra domain entrance quizzes evaluating foundational domain concepts.

5. **Nalanda University Interactive Domain Puzzles**:
   - **Mathematics Challenge**: Number calculation & pattern recognition puzzles.
   - **Astronomy Challenge**: Night sky constellation star alignment (Saptarishi, Scholar's Arc, Zenith Diamond).
   - **Medicine Challenge**: Ayurvedic herbal diagnosis and symptom treatment (Tulsi, Neem, Amla, Ginger, Turmeric, Ashoka).
   - **Philosophy Challenge**: Dialectical debate rounds testing logical reasoning (*Tarka*) and moral discernment (*Cetana*).

---

## 🎮 Game Controls

| Action | Control / Key | Description |
| :--- | :---: | :--- |
| **Movement** | `W` / `A` / `S` / `D`  or  `Arrow Keys` | Move player character across Nalanda maps |
| **Interact / Talk** | `E` | Talk to NPCs (Merchant, Silabhadra) & trigger dialogue |
| **Building Info** | `I`  or  `[ i ]` Button | View historical & architectural information |
| **Pause / Close** | `ESC` | Pause game, close menus & UI popups |
| **UI Selection** | `Mouse / Click` | Select dialogue choices, puzzle tiles, and buttons |

---

## 🛠️ Project Architecture & Tech Stack

- **Game Engine**: Godot Engine 4.x
- **Scripting Language**: GDScript (Strictly type-checked, 0 parsing errors across 41 scripts)
- **Physics**: Jolt Physics 2D
- **Rendering**: Compatibility Mode (OpenGL3 / D3D12 fallback)
- **Typography**: Custom fonts (`Oswald`, `Pixelify Sans`)
- **Media Transcoding**: Native `.ogv` video streams for cross-platform compatibility

```
dharohar-1.0/
├── assets/                  # Sprites, UI packs, fonts, audio & video cutscenes
│   ├── videos/              # video1.ogv, video2.ogv, video3.ogv
│   └── Oswald/              # Font assets
├── scenes/                  # Game scenes (.tscn)
│   ├── experiences/         # Experience Screen selection
│   ├── nalanda/             # Nalanda Map & logic
│   └── ui/                  # CutsceneUI, ControlsTutorialUI, Quizzes, Puzzles
├── scripts/                 # System managers & NPC logic
│   ├── data/                # QuestionData.gd
│   ├── npcs/                # Merchant.gd, Teacher.gd
│   ├── puzzles/             # Mathematics, Astronomy, Medicine, Philosophy puzzle logic
│   └── systems/             # GameState.gd, CutscenePlayer.gd, ControlsTutorialPlayer.gd
└── project.godot            # Root Godot Engine project file
```

---

## 🚀 How to Run the Project

1. **Prerequisites**: Install [Godot Engine 4.x (64-bit)](https://godotengine.org/).
2. **Open Project**:
   - Launch Godot Engine.
   - Click **Import** and select `dharohar-1.0/project.godot`.
   - Click **Import & Edit**.
3. **Play Game**:
   - Press `F5` or click the **Play Project** button in top-right corner to launch the main scene.

---

## 📄 Documentation & Game Guide

A complete 2-page Word Document Game Guide (`Dharohar_Game_Guide.docx`) is included in the project root containing full walkthroughs, quiz answer keys, and step-by-step puzzle solutions.
