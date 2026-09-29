class_name AstronomyMasteryData
extends RefCounted

# ==============================================================================
# DHAROHAR 1.0 — ASTRONOMY MASTERY (3 LEVELS)
# ==============================================================================
# Level 1: The Moon's Journey (Moon phase sequencing + Observation dial + Mini observations)
# Level 2: Reading the Sky (Terrace board: Find the East + Match star pattern + Follow the star)
# Level 3: The Astronomer's Final Observation (Field Notebook multi-parameter deduction)
# ==============================================================================

const LEVELS: Array[Dictionary] = [
	{
		"id": "moon_journey",
		"level_number": 1,
		"title": "The Moon's Journey",
		"nav_label": "1. The Moon's Journey",
		"subtitle": "Level 1 of 3 — Visual Recognition & Lunar Progression",
		"instructions": "Arrange the five lunar phase tablets in the exact order of the Moon's natural waxing journey from dark to illumination.",
		"complete_quote": "You observed the changing face of Soma. The Moon does not change its nature, only its dance with light and earth.",
		"phase_sequence": [
			{
				"id": "new_moon",
				"name": "New Moon",
				"sanskrit": "Amavasya",
				"symbol": "🌑",
				"visual_desc": "Completely Dark Disk",
				"order_index": 0
			},
			{
				"id": "crescent",
				"name": "Waxing Crescent",
				"sanskrit": "Shukla Dvitiya",
				"symbol": "🌒",
				"visual_desc": "Slender Curved Silver Bow",
				"order_index": 1
			},
			{
				"id": "first_quarter",
				"name": "First Quarter",
				"sanskrit": "Ardha Chandra",
				"symbol": "🌓",
				"visual_desc": "Half Illuminated Disk",
				"order_index": 2
			},
			{
				"id": "gibbous",
				"name": "Waxing Gibbous",
				"sanskrit": "Shukla Trayodashi",
				"symbol": "🌔",
				"visual_desc": "More Than Half Illuminated",
				"order_index": 3
			},
			{
				"id": "full_moon",
				"name": "Full Moon",
				"sanskrit": "Purnima",
				"symbol": "🌕",
				"visual_desc": "Fully Illuminated Golden Orb",
				"order_index": 4
			}
		],
		"mini_observations": [
			{
				"prompt": "An ancient scholar sketched this lunar appearance on a palm leaf:\n\n[center][b][color=#ffdd88]Slender curved sliver of light illuminated on the right.[/color][/b][/center]\n\nWhich phase of the lunar journey was observed?",
				"target_symbol": "🌒",
				"options": ["Full Moon (Purnima)", "Waxing Crescent (Shukla Dvitiya)", "New Moon (Amavasya)", "First Quarter (Ardha Chandra)"],
				"correct": 1,
				"explanation": "A slender curved crescent illuminated on the right marks the Waxing Crescent phase, just following the New Moon.",
				"hint": "Notice that only a small crescent curve is reflecting sunlight."
			},
			{
				"prompt": "The scholar observed the Moon exactly half illuminated ([b]🌓 First Quarter[/b]).\n\nAs time progresses in the waxing fortnight (Shukla Paksha), which phase comes immediately next?",
				"target_symbol": "🌓",
				"options": ["Waxing Gibbous (🌔)", "New Moon (🌑)", "Waning Crescent (🌘)", "Dark Sky (No Moon)"],
				"correct": 0,
				"explanation": "In the waxing journey, the First Quarter (🌓) grows into the Waxing Gibbous (🌔) as illumination exceeds 50% on its way to the Full Moon.",
				"hint": "In the waxing cycle, the light continues to expand past half illumination."
			}
		]
	},
	{
		"id": "reading_sky",
		"level_number": 2,
		"title": "Reading the Sky",
		"nav_label": "2. Reading the Sky",
		"subtitle": "Level 2 of 3 — Direction, Constellations & Observational Alignment",
		"instructions": "Stand on the ancient Nalanda observation terrace. Orient your compass, identify the celestial patterns, and mark the scholar's recorded stars.",
		"complete_quote": "The sky is a timeless map. By fixing the horizon and patterns of stars, a scholar is never lost in space or time.",
		"challenges": [
			{
				"sub_id": "find_east",
				"sub_title": "Observation A: The Rising Sun & Cardinal Orientation",
				"instructions": "Examine the dawn horizon on the scholar's observation board. The radiant golden Sun is ascending above the tree line. Select the cardinal direction marker that corresponds to the sunrise.",
				"horizon_view": "🌅 [ DAWN HORIZON — RISING GOLDEN SUN ASCENDING OVER SACRED HILLS ]",
				"compass_options": ["NORTH (Uttara)", "EAST (Purva)", "SOUTH (Dakshina)", "WEST (Pashchima)"],
				"correct": 1,
				"explanation": "The Sun always rises in the East (Purva), providing the foundational cardinal orientation for ancient Indian astronomical observatories.",
				"hint": "Consider where the dawn illumination emerges every morning across the sky."
			},
			{
				"sub_id": "star_pattern",
				"sub_title": "Observation B: Star Pattern & Relative Position Recognition",
				"instructions": "Examine the Target Sky Pattern observed through the Nalanda sighting tube. Compare the relative positions of the bright stars and select the matching slate from the three scholar's records.",
				"target_pattern_name": "Saptarshi / The Celestial Anchor",
				"target_diagram": "      ★ (Alkaid)\n   ★     ★ (Mizar & Alioth)\n        ★\n  ★         ★\n       ★ (Kratu / Merak)",
				"candidate_patterns": [
					{
						"label": "Slate 1: Linear Alignments",
						"diagram": "★ ── ★ ── ★ ── ★ ── ★\n(Straight linear line of stars)",
						"is_match": false
					},
					{
						"label": "Slate 2: The Seven Anchor Points",
						"diagram": "      ★ \n   ★     ★ \n        ★\n  ★         ★\n       ★",
						"is_match": true
					},
					{
						"label": "Slate 3: Triangular Cluster",
						"diagram": "       ★\n     ★   ★\n   ★   ★   ★\n(Tight triangular pyramid)",
						"is_match": false
					}
				],
				"correct": 1,
				"explanation": "Slate 2 matches the exact relative spatial geometry and distinct four-star bowl with three-star handle observed on the sky plate.",
				"hint": "Carefully trace the distinct bent handle connecting to the four-star box."
			},
			{
				"sub_id": "follow_star",
				"sub_title": "Observation C: Follow the Recorded Luminary",
				"instructions": "The scholar's log states: 'The primary beacon Dhruva (Pole Star) remains steadfast high above the northern horizon marker, while lesser stars revolve around it.' Select the steadfast beacon position on the celestial grid.",
				"sky_grid_title": "🌌 NALANDA OBSERVATION GRID — NORTHERN SKY",
				"star_nodes": [
					{"id": "star_a", "label": "Point A (Low Eastern Horizon)", "desc": "Eastern rising star", "is_correct": false},
					{"id": "star_b", "label": "Point B (True North Pivot — Dhruva)", "desc": "Steadfast northern focal star", "is_correct": true},
					{"id": "star_c", "label": "Point C (Low Western Setting Point)", "desc": "Western setting luminary", "is_correct": false},
					{"id": "star_d", "label": "Point D (Southern Meridian Arc)", "desc": "Southern transient star", "is_correct": false}
				],
				"correct": 1,
				"explanation": "Point B marks the northern celestial pivot (Dhruva / North Star), which remains stationary and centered directly above the northern horizon.",
				"hint": "Look for the central anchor star positioned directly north where the rotation axis points."
			}
		]
	},
	{
		"id": "final_observation",
		"level_number": 3,
		"title": "The Astronomer's Final Observation",
		"nav_label": "3. Final Observation",
		"subtitle": "Level 3 of 3 — Synthesis of Time, Phase, Direction & Celestial Logic",
		"instructions": "Analyze the scholar's field notes from the observatory terrace. Stamp each observation parameter into your Field Notebook and submit the complete celestial record.",
		"complete_quote": "You did not simply look at the sky. You learned to observe it, compare it, and draw meaning from what you saw. That is the beginning of true astronomical understanding.",
		"scenario": {
			"title": "OBSERVATION FIELD LOG — DUSK OVER NALANDA",
			"context": "The scholar ascends the terrace at the end of the day. The setting sun paints the western horizon in deep crimson. Looking up into the twilight sky, the Moon is seen as a radiant half-illuminated disk (Ardha Chandra). High in the eastern sky, the distinctive seven-star constellation (Saptarshi) shines with crystalline clarity during the pleasant post-monsoon autumn season.",
			"fields": [
				{
					"key": "season",
					"title": "Season (Ritu)",
					"options": ["Vasant (Spring)", "Grishma (Summer)", "Varsha (Monsoon)", "Sharad (Autumn)"],
					"correct": 3,
					"clue": "Clear post-monsoon skies and pleasant cool evenings indicate Sharad Ritu (Autumn)."
				},
				{
					"key": "time",
					"title": "Time of Day",
					"options": ["🌅 Dawn / Sunrise", "☀ High Noon", "🌇 Sunset / Dusk", "🌙 Deep Midnight"],
					"correct": 2,
					"clue": "The setting sun painting the western horizon in crimson confirms Sunset / Dusk."
				},
				{
					"key": "moon_phase",
					"title": "Observed Moon Phase",
					"options": ["🌑 New Moon (Amavasya)", "🌒 Crescent (Dvitiya)", "🌓 First Quarter (Ardha Chandra)", "🌕 Full Moon (Purnima)"],
					"correct": 2,
					"clue": "The field note records the Moon as an exactly half-illuminated disk (First Quarter)."
				},
				{
					"key": "direction",
					"title": "Horizon of Sunset",
					"options": ["North (Uttara)", "East (Purva)", "South (Dakshina)", "West (Pashchima)"],
					"correct": 3,
					"clue": "The Sun sets in the West (Pashchima)."
				},
				{
					"key": "star_pattern",
					"title": "Identified Constellation",
					"options": ["Trishula (The Trident)", "Saptarshi (The Seven Sages)", "Mriga (The Celestial Deer)", "Matsya (The Twin Fish)"],
					"correct": 1,
					"clue": "The distinctive seven-star constellation mentioned is the Saptarshi."
				}
			],
			"synthesis": {
				"title": "CELESTIAL SYNTHESIS VERIFIED",
				"summary": "Every parameter of your field notebook balances flawlessly with celestial mechanics:\n\n• [b]Sharad Ritu (Autumn)[/b] provides the tranquil clear atmosphere.\n• [b]Sunset / Dusk[/b] in the [b]West[/b] reveals the emerging evening stars.\n• [b]First Quarter Moon (🌓)[/b] stands high above the southern meridian at dusk.\n• [b]Saptarshi[/b] anchors the eastern heavens, marking the passage of the evening hour.",
				"quote": "In ancient Nalanda, astronomy was never mere speculation. It was the art of patient observation, disciplined measurement, and reverence for cosmic harmony."
			}
		}
	}
]

static func get_level_count() -> int:
	return LEVELS.size()

static func get_level(idx: int) -> Dictionary:
	if idx >= 0 and idx < LEVELS.size():
		return LEVELS[idx]
	return {}

static func get_level_by_id(level_id: String) -> Dictionary:
	var l_id := level_id.to_lower().strip_edges()
	for lvl in LEVELS:
		if lvl.get("id", "").to_lower() == l_id:
			return lvl
	return {}
