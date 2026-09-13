DHAROHAR 1.0 — ENTER NAME UI PACK
====================================

Style:
Ancient Nalanda / Indian heritage pixel-art UI, parchment + maroon + gold + carved-wood accents.

Contents:
- enter_name_ui_full_transparent.png
- dialog_panel.png
- dialog_panel_blank.png
- top_crest.png
- bottom_crest.png
- name_input_field.png
- back_button.png
- begin_journey_button.png
- left_corner_top.png
- right_corner_top.png
- left_corner_bottom.png
- right_corner_bottom.png

Godot 4 usage:
1. Import PNGs as Texture2D.
2. For scalable UI, place the panel/buttons inside Control nodes.
3. Use TextureRect/TextureButton as appropriate.
4. Set texture filtering to nearest where you want crisp pixel-art edges.
5. For the main frame, use 9-patch/nine-patch style scaling if needed so the corners stay intact.
6. The supplied full asset has its near-black background made transparent.

Note:
The supplied source artwork contains baked text ("SCHOLAR OF NALANDA", "Pushpendra", button labels).
For production, use the modular frame pieces and place Godot text controls over them when you need editable text.
