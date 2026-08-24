class_name AstronomyPuzzles
extends Node

static func get_puzzles() -> Array:
	return [
		{
			"id": 1,
			"title": "Triangular Celestial Alignment",
			"instructions": "Observe the night sky. Select and connect the three main stars that form the scholar's triangle.",
			"clues": [
				"1. Identify the bright zenith star at the top.",
				"2. Connect down to the western horizon star.",
				"3. Complete the triangle at the eastern star."
			],
			"star_positions": [
				Vector2(190, 45),
				Vector2(65, 215),
				Vector2(315, 215)
			],
			"valid_sequences": [
				[0, 1, 2, 0],
				[0, 2, 1, 0],
				[0, 1, 2],
				[0, 2, 1]
			],
			"hint": "Begin at the top star and connect all three points.",
			"explanation": "Ancient Nalanda astronomers mapped triangular star alignments to track seasonal solstices."
		},
		{
			"id": 2,
			"title": "The Scholar's Arc",
			"instructions": "Follow the celestial directional clues to draw the curved arc across the sky.",
			"clues": [
				"1. Begin at the bright western star.",
				"2. Move northeast to the central peak star.",
				"3. Descend southeast to the eastern star."
			],
			"star_positions": [
				Vector2(55, 195),
				Vector2(190, 55),
				Vector2(325, 195)
			],
			"valid_sequences": [
				[0, 1, 2],
				[2, 1, 0]
			],
			"hint": "Follow the stars from left to right across the central peak star.",
			"explanation": "Curved stellar paths helped ancient observers track the nightly transit of major constellations."
		},
		{
			"id": 3,
			"title": "The Zenith Diamond",
			"instructions": "Reconstruct the 4-star diamond constellation surrounding the zenith marker.",
			"clues": [
				"1. Start at the top zenith star.",
				"2. Connect clockwise: West, South, East, and back to North."
			],
			"star_positions": [
				Vector2(190, 40),
				Vector2(75, 135),
				Vector2(190, 230),
				Vector2(305, 135)
			],
			"valid_sequences": [
				[0, 1, 2, 3, 0],
				[0, 3, 2, 1, 0],
				[0, 1, 2, 3],
				[0, 3, 2, 1]
			],
			"hint": "Connect the four cardinal stars in a continuous loop.",
			"explanation": "Diamond groupings served as celestial navigation anchors for night travellers across ancient India."
		},
		{
			"id": 4,
			"title": "Distractor Stars & The Quadrant",
			"instructions": "Identify the 4 true constellation stars forming the square and ignore distractor lights.",
			"clues": [
				"1. Connect the four outer corner stars to form a square.",
				"2. Ignore the faint flickering center and far-left distractor stars."
			],
			"star_positions": [
				Vector2(95, 55),
				Vector2(285, 55),
				Vector2(285, 215),
				Vector2(95, 215),
				Vector2(190, 135),
				Vector2(35, 135)
			],
			"valid_sequences": [
				[0, 1, 2, 3, 0],
				[0, 3, 2, 1, 0],
				[0, 1, 2, 3],
				[0, 3, 2, 1]
			],
			"hint": "Ignore the center star and outer left star.",
			"explanation": "Scholars learned to distinguish fixed major stars from flickering atmospheric distortions."
		},
		{
			"id": 5,
			"title": "Saptarishi — The Seven Celestial Rishis",
			"instructions": "Connect the 7 sacred stars of Saptarishi (Great Bear): the 4-star bowl and the 3-star handle.",
			"clues": [
				"1. Start at the bottom-left bowl star.",
				"2. Move across the bowl base to the right.",
				"3. Ascend up through the bowl to the handle.",
				"4. Connect all 7 stars along the celestial scoop."
			],
			"star_positions": [
				Vector2(65, 195),
				Vector2(150, 195),
				Vector2(170, 125),
				Vector2(85, 125),
				Vector2(245, 85),
				Vector2(305, 100),
				Vector2(350, 140)
			],
			"valid_sequences": [
				[0, 1, 2, 3, 4, 5, 6],
				[0, 1, 2, 4, 5, 6],
				[0, 3, 2, 1, 0, 2, 4, 5, 6],
				[6, 5, 4, 2, 1, 0],
				[6, 5, 4, 2, 3, 0, 1]
			],
			"hint": "Connect from the lower-left bowl star through to the tip of the handle on the right.",
			"explanation": "Saptarishi (Seven Sages / Great Bear) was the foundational constellation studied by ancient Nalanda astronomers."
		}
	]
