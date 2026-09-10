class_name NarrativeMasteryData
extends RefCounted

# ==============================================================================
# NALANDA STORY MASTERY SYSTEM — DETROIT-INSPIRED NARRATIVE DATA
# ==============================================================================

const CHAPTER_STUPA: Dictionary = {
	"id": "stupa",
	"title": "The Great Stupa — Foundation & Alignment Dilemma",
	"location": "Great Stupa of Nalanda",
	"intro": [
		{"speaker": "Stupa Caretaker", "text": "Pranam! The monsoons have weakened the eastern terrace of the Great Stupa."},
		{"speaker": "Master Builder", "text": "If we rush to rebuild using heavy stone blocks before tomorrow's auspicious festival, the damp soil may shift!"},
		{"speaker": "Stupa Caretaker", "text": "Yet the pilgrims arrive tomorrow at dawn. The Council is divided on how to proceed."}
	],
	"clues": [
		"• Soil Moisture: The eastern embankment soil is saturated with water and requires drainage.",
		"• Structural Load: The upper dome weight exerts 40% more downward pressure on the eastern archway.",
		"• Solar Alignment: The dawn shadow of the finial must align with the equinox marker during the festival."
	],
	"domain_insights": {
		"mathematics": "[Mathematics Insight] Calculating load distribution shows that distributing weight through tiered timber buttresses reduces ground pressure by 60% without waiting weeks for soil curing.",
		"astronomy": "[Astronomy Insight] Observation of the morning shadow indicates that the primary celestial alignment line falls along the central axis, leaving the eastern terrace non-critical for the dawn ritual.",
		"medicine": "[Medicine Insight] Traditional knowledge of soil treatment prescribes burning dry lime and river gravel into the damp earth to rapidly absorb excess moisture and prevent mold decay.",
		"philosophy": "[Philosophy Insight] Applying reasoned balance: preservation of life and sacred sanctity must outweigh haste; a transparent temporary ritual path respects pilgrims while safeguarding the monument."
	},
	"choices": [
		{
			"id": "choice_a",
			"text": "A) Expedite heavy stone masonry immediately to finish before dawn.",
			"consequence": "Immediate: The terrace is paved in time for the festival.\nOutcome: Heavy masonry cracks under ground settlement within days, requiring costly emergency repairs.",
			"reaction": "The Caretaker thanks you for punctuality, but the Builder shakes his head in worry.",
			"is_optimal": false
		},
		{
			"id": "choice_b",
			"text": "B) Cordon off the entire Stupa grounds and cancel the pilgrim festival.",
			"consequence": "Immediate: The structure is protected from all disturbance.\nOutcome: Hundreds of traveling pilgrims are disappointed, creating distress across the university.",
			"reaction": "The Builder feels safe, but the monks and pilgrims feel the decision lacked empathy.",
			"is_optimal": false
		},
		{
			"id": "choice_c",
			"text": "C) Install temporary timber buttresses and a gravel-drained bypass for pilgrims, allowing structured restoration after the festival.",
			"consequence": "Immediate: Pilgrims safely celebrate the festival while the sacred monument remains protected.\nOutcome: The balanced engineering plan becomes a praised model of prudent Nalanda stewardship.",
			"reaction": "Both the Caretaker and Master Builder enthusiastically praise your wise, balanced judgment!",
			"is_optimal": true
		}
	],
	"scroll_name": "Stupa Scroll of Prudence",
	"exp_reward": 100
}

const CHAPTER_LIBRARY: Dictionary = {
	"id": "library",
	"title": "Dharmaganja Library — The Disputed Palm-Leaf Treatises",
	"location": "Dharmaganja Library (Ratnasagara)",
	"intro": [
		{"speaker": "Head Scribe", "text": "Welcome to the Ratnasagara archives. We have a serious scholarly dispute."},
		{"speaker": "Visiting Scholar", "text": "This northern palm-leaf manuscript claims our eclipse calculation formula contains an error of three ghatikas!"},
		{"speaker": "Resident Scholar", "text": "Nonsense! That treatise was copied hastily during the winter famine and omitted foundational commentary!"}
	],
	"clues": [
		"• Folio Markings: The northern manuscript has newer ink marginalia added in a different handwriting.",
		"• Calculation Method: The resident treatise uses Aryabhata's sine tables; the northern copy uses simplified approximations.",
		"• Cross-Reference: A third ancient commentary by Acharya Varahamihira resides in the lower vault."
	],
	"domain_insights": {
		"mathematics": "[Mathematics Insight] Comparing numerical tables reveals the discrepancy is a rounding error in the second-order interpolation of the northern text.",
		"astronomy": "[Astronomy Insight] Cross-checking against historical eclipse records shows the resident formula accurately matched the lunar occultation of Magha three years ago.",
		"medicine": "[Medicine Insight] Inspecting ink composition and palm-leaf degradation proves the northern margin note was added decades later with non-traditional soot ink.",
		"philosophy": "[Philosophy Insight] Epistemological inquiry (Hetuvidya) reveals the opponent's claim rests on an unverified premise without establishing a valid source of knowledge (Pramana)."
	},
	"choices": [
		{
			"id": "choice_a",
			"text": "A) Authorize burning the disputed northern manuscript as an erroneous copy.",
			"consequence": "Immediate: The dispute is silenced.\nOutcome: A rare historical dialectical perspective is lost forever, violating Nalanda's spirit of open debate.",
			"reaction": "The Resident Scholar is pleased, but the Head Scribe mourns the destruction of ancient knowledge.",
			"is_optimal": false
		},
		{
			"id": "choice_b",
			"text": "B) Declare the northern version completely authoritative to maintain external diplomatic harmony.",
			"consequence": "Immediate: The visiting delegation is flattered.\nOutcome: Students adopt inaccurate calculation constants, leading to erroneous observatory records.",
			"reaction": "The Visiting Scholar is triumphant, but Nalanda's astronomical precision is compromised.",
			"is_optimal": false
		},
		{
			"id": "choice_c",
			"text": "C) Annotate both treatises side-by-side with mathematical proofs and place Varahamihira's cross-reference in the public reading hall.",
			"consequence": "Immediate: The discrepancy is resolved through transparent evidence and comparative analysis.\nOutcome: The comparative monograph becomes a celebrated teaching tool for future generations.",
			"reaction": "Both scholars bow respectfully in agreement, honoring Nalanda's relentless pursuit of truth.",
			"is_optimal": true
		}
	],
	"scroll_name": "Library Scroll of Truth",
	"exp_reward": 100
}

const CHAPTER_VIHARA: Dictionary = {
	"id": "vihara",
	"title": "Vihara Living Quarters — The Winter Provision Dilemma",
	"location": "Vihara Residential Quarters",
	"intro": [
		{"speaker": "Vihara Elder", "text": "Peace be with you. As winter approaches, we face a crucial distribution challenge."},
		{"speaker": "Dispensary Monk", "text": "Our medicinal warming oils, firewood, and dried grains are in limited supply due to late harvest rains."},
		{"speaker": "Student Leader", "text": "The junior novice students are freezing in the northern dormitories, while senior scholars require lamps for nocturnal research!"}
	],
	"clues": [
		"• Environmental Thermal Flow: The southern stone halls retain daytime solar warmth 4 hours longer than the northern wing.",
		"• Health Demands: Novice students are vulnerable to cold-induced respiratory congestion (Kaphaja vikar).",
		"• Scholarly Needs: Advanced research debates conclude two hours past sundown."
	],
	"domain_insights": {
		"mathematics": "[Mathematics Insight] Rationing equations show that consolidating late-night study into two central heated halls saves 45% of total lamp oil.",
		"astronomy": "[Astronomy Insight] Rotating dormitory occupancy according to solar elevation maximizes daylight warmth for younger students during winter months.",
		"medicine": "[Medicine Insight] Distributing warming Tulsi-Ginger infusions and sesame oil massage to northern dormitories prevents chills effectively with minimal timber consumption.",
		"philosophy": "[Philosophy Insight] Applying distributive justice: equity requires caring for the most vulnerable first, while creating shared community spaces for scholarly duties."
	},
	"choices": [
		{
			"id": "choice_a",
			"text": "A) Give all heating supplies exclusively to senior scholars to ensure uninterrupted research.",
			"consequence": "Immediate: Senior research continues at full capacity.\nOutcome: Several novice students fall ill, disrupting morning classes and spreading sickness.",
			"reaction": "The seniors appreciate the warmth, but the Vihara community feels fractured.",
			"is_optimal": false
		},
		{
			"id": "choice_b",
			"text": "B) Divide supplies equally by headcount regardless of room temperature or health needs.",
			"consequence": "Immediate: Equal mathematical distribution is applied.\nOutcome: Southern rooms waste firewood while freezing northern rooms remain inadequately warmed.",
			"reaction": "The distribution feels superficially fair, but practical suffering remains unaddressed.",
			"is_optimal": false
		},
		{
			"id": "choice_c",
			"text": "C) Implement dynamic allocation: relocate novices to insulated quarters, provide herbal warmth, and consolidate nocturnal study in a shared heated library.",
			"consequence": "Immediate: All students remain healthy while research continues efficiently without fuel shortages.\nOutcome: The harmonious management protocol is adopted as Nalanda's standard winter guideline.",
			"reaction": "The Elder, Dispensary Monk, and Student Leader join in profound gratitude for your empathetic wisdom!",
			"is_optimal": true
		}
	],
	"scroll_name": "Vihara Scroll of Harmony",
	"exp_reward": 100
}

# ==============================================================================
# FINAL MASTERY SCENARIOS — DOMAIN SPECIFIC
# ==============================================================================

const FINAL_MASTERY_SCENARIOS: Dictionary = {
	"mathematics": {
		"domain": "Mathematics",
		"title": "Final Mastery Trial — The Grand University Logistical Blueprint",
		"subtitle": "Mastery of Ganita: Proportion, Resource Allocation & Spatial Geometry",
		"narrative": [
			{"speaker": "Teacher 3", "text": "Welcome, mathematician. For your final trial, the University Council has entrusted you with planning the Grand Nalanda Convocation."},
			{"speaker": "Teacher 3", "text": "You must balance the needs of 200 visiting delegates, grain granaries, pavilion construction timber, and emergency reserve funds over a 90-day monsoon season."},
			{"speaker": "Teacher 3", "text": "Examine the logistics ledger and synthesize the optimal blueprint that guarantees university prosperity."}
		],
		"investigation_clues": [
			"• Daily Consumption: 200 scholars require 300 measures of grain daily (1.5 measures/scholar). Total base = 27,000 measures.",
			"• Granary Capacity: Maximum storage is 35,000 measures. Rain spoilage risk is 5% if unsealed.",
			"• Timber Constraint: 60 structural cedar beams are required for 3 discussion mandapas (20 beams each).",
			"• Contingency Rule: Ancient Nalanda ordinance mandates a 15% emergency reserve on all rations."
		],
		"challenge_prompt": "Formulate the comprehensive mathematical allocation for the 90-day academic session:",
		"choices": [
			{
				"id": "math_opt_1",
				"text": "A) Authorize 31,050 grain measures (27,000 base + 15% reserve), allocate 60 cedar beams across 3 mandapas, and apply 1,350 measures for granary sealing protection.",
				"is_correct": true,
				"explanation": "Base grain: 200 × 90 × 1.5 = 27,000. 15% reserve = 4,050. Total grain = 31,050 (safely within the 35,000 limit). Timber: 3 × 20 = 60 beams. This mathematically harmonizes supply, structure, and risk protection.",
				"feedback": "Flawless computation! You have mastered the application of Ganita to real-world governance and architectural logistics."
			},
			{
				"id": "math_opt_2",
				"text": "B) Authorize exactly 27,000 grain measures with 0% reserve and construct 5 mandapas using 100 timber beams on credit.",
				"is_correct": false,
				"explanation": "Omits the mandatory 15% safety buffer and over-allocates timber beyond available cedar reserves.",
				"feedback": "Calculations failed to account for safety tolerances and material limits."
			},
			{
				"id": "math_opt_3",
				"text": "C) Allocate 10,000 grain measures and reduce delegate stay to 30 days while cancelling pavilion construction.",
				"is_correct": false,
				"explanation": "Arbitrarily curtails the convocation scope rather than solving the allocation system.",
				"feedback": "Avoid evading constraints through arbitrary reductions; rigorous planning solves the full problem."
			}
		],
		"exp_reward": 200
	},
	"astronomy": {
		"domain": "Astronomy",
		"title": "Final Mastery Trial — The Great Celestial Calendar & Eclipse Reckoning",
		"subtitle": "Mastery of Jyotisha: Celestial Observation, Nakshatras & Chronology",
		"narrative": [
			{"speaker": "Teacher 3", "text": "Welcome, astronomer. For your final trial, the Nalanda Observatory requires your synthesis of celestial observations."},
			{"speaker": "Teacher 3", "text": "Three traveling delegations have arrived with conflicting lunar-solar calendars for the upcoming royal consecration and solar eclipse."},
			{"speaker": "Teacher 3", "text": "Analyze the planetary gnomon records and determine the precise astronomical reality."}
		],
		"investigation_clues": [
			"• Observation 1: The midday gnomon shadow is at its absolute minimum annual length, indicating Summer Solstice (Dakshinayana transition).",
			"• Observation 2: The Moon enters conjunction with Pushya Nakshatra at the new moon phase (Amavasya).",
			"• Observation 3: Rahu (the ascending lunar node) is aligned within 1.5 degrees of the Sun's ecliptic longitude.",
			"• Observation 4: Mercury and Venus are observed in the western sky at dusk, confirming twilight visibility."
		],
		"challenge_prompt": "Synthesize the astronomical deductions to determine the precise celestial phenomenon:",
		"choices": [
			{
				"id": "astro_opt_1",
				"text": "A) A Total Solar Eclipse (Surya Grahana) will occur on the Amavasya of Ashadha at the Summer Solstice, with Venus and Mercury visible during daytime totality.",
				"is_correct": true,
				"explanation": "New Moon (Amavasya) with Rahu within 1.5° of the Sun guarantees a solar eclipse. Minimum shadow length confirms Summer Solstice in the month of Ashadha. Totality reveals bright interior planets (Venus & Mercury).",
				"feedback": "Brilliant astronomical deduction! You have demonstrated true mastery of observational Jyotisha and celestial mechanics."
			},
			{
				"id": "astro_opt_2",
				"text": "B) A Lunar Eclipse (Chandra Grahana) will occur during the Full Moon of Kartika during the Autumn Equinox.",
				"is_correct": false,
				"explanation": "The observations describe New Moon (Amavasya) at the Summer Solstice, not Full Moon in Kartika.",
				"feedback": "Incorrect phase and season. Amavasya conjunction with the solar node causes solar, not lunar, eclipses."
			},
			{
				"id": "astro_opt_3",
				"text": "C) No eclipse is possible because shadows are shortest in winter.",
				"is_correct": false,
				"explanation": "Midday shadows are shortest at the Summer Solstice, when the Sun reaches peak altitude.",
				"feedback": "Fundamental error in solar elevation and shadow dynamics."
			}
		],
		"exp_reward": 200
	},
	"medicine": {
		"domain": "Medicine",
		"title": "Final Mastery Trial — The Seasonal Epidemic & Botanical Harmony",
		"subtitle": "Mastery of Ayurveda & Cikitsa: Dosha Balance, Botanical Formulations & Public Health",
		"narrative": [
			{"speaker": "Teacher 3", "text": "Welcome, healer. For your final trial, an outbreak of seasonal fever and digestive weakness has affected the eastern monasteries during the post-monsoon autumn (Sharad Ritu)."},
			{"speaker": "Teacher 3", "text": "The humid heat causes Pitta dosha aggravation combined with accumulated metabolic toxins (Ama)."},
			{"speaker": "Teacher 3", "text": "Formulate the master public health and botanical treatment regimen to restore the university community to vibrant harmony."}
		],
		"investigation_clues": [
			"• Patient Symptoms: Burning sensation, feverish heat, bitter mouth taste, and digestive sluggishness.",
			"• Environmental Factor: Post-monsoon clear skies increase solar heat (Tikshna Ushna) reacting with dampness.",
			"• Available Herbs: Amalaki (cooling antioxidant), Guduchi (immunomodulatory bitter), Chandana (sandalwood), and Pippali (digestive enhancer).",
			"• Dietary Context: Stagnant water and unboiled well water are amplifying impurities."
		],
		"challenge_prompt": "Select the comprehensive Ayurvedic clinical and environmental protocol:",
		"choices": [
			{
				"id": "med_opt_1",
				"text": "A) Protocol: Boil all drinking water with Usheera & Musta; prescribe bitter-cooling decoctions of Guduchi & Amalaki; administer light, sweet-bitter gruels (Mudga Yusha); and mandate shaded rest during peak afternoon heat.",
				"is_correct": true,
				"explanation": "Sharad Ritu Pitta pacification requires bitter (Tikta) and sweet (Madhura) cooling botanical decoctions (Guduchi, Amalaki), water purification with cooling aromatics (Usheera), and easily assimilable mung bean broths to clear Ama.",
				"feedback": "Exceptional clinical wisdom! You have proven profound mastery in the timeless principles of Ayurvedic balance and public health."
			},
			{
				"id": "med_opt_2",
				"text": "B) Administer heavy spicy oils, mustard seeds, and direct sunlight exposure to force perspiration.",
				"is_correct": false,
				"explanation": "Pungent spices and intense heat exacerbate Pitta and inflammation during Sharad Ritu.",
				"feedback": "Pungent and heating treatments severely aggravate autumn Pitta fevers."
			},
			{
				"id": "med_opt_3",
				"text": "C) Enforce absolute fasting for 14 days without water or medicinal infusions.",
				"is_correct": false,
				"explanation": "Prolonged starvation severely depletes vital bodily tissues (Dhatus) and worsens dehydration.",
				"feedback": "Excessive starvation causes severe physical deterioration."
			}
		],
		"exp_reward": 200
	},
	"philosophy": {
		"domain": "Philosophy",
		"title": "Final Mastery Trial — The Great Convocation Debate",
		"subtitle": "Mastery of Hetuvidya & Darsana: Epistemology, Formal Logic & Dialectics",
		"narrative": [
			{"speaker": "Teacher 3", "text": "Welcome, philosopher. For your final trial, you stand before the Council of Acharyas in the Great Debate Courtyard."},
			{"speaker": "Teacher 3", "text": "A renowned visiting dialectician has presented a sweeping challenge to the foundation of education itself."},
			{"speaker": "Visiting Dialectician", "text": "'Perception is unreliable, language is arbitrary convention, and reasoning produces only endless regress. Therefore, no genuine knowledge (Prama) can ever be established!'"},
			{"speaker": "Teacher 3", "text": "Construct the definitive philosophical defense demonstrating the validity of knowledge and the purpose of learning."}
		],
		"investigation_clues": [
			"• Opponent's Thesis: Universal skepticism (All claims to knowledge are fundamentally invalid).",
			"• Self-Contradiction (Vyaghata): If no knowledge is valid, the opponent's own assertion cannot claim to be valid knowledge.",
			"• Pramana Framework: Perception (Pratyaksha) and valid inference (Anumana) mutually verify experience through fruitful action (Samvada / Arthakriya-samarthya).",
			"• Epistemological Purpose: Knowledge is verified when actions based on it successfully achieve intended outcomes."
		],
		"challenge_prompt": "Formulate the rigorous dialectical refutation (Khandana) and constructive defense (Sadhana):",
		"choices": [
			{
				"id": "phil_opt_1",
				"text": "A) Refutation: Universal skepticism is self-refuting (Vyaghata)—if nothing can be known, the claim itself cannot be known as true. Defense: Knowledge is validated through causal efficacy (Arthakriya) and coherent inference (Anumana), as proven by purposeful action and cumulative human discovery.",
				"is_correct": true,
				"explanation": "Classical Indian logic refutes absolute skepticism by showing inherent self-contradiction: to assert that knowledge is impossible presupposes knowledge of that fact. The validity of Pramanas is established through pragmatic efficacy (Arthakriya-karitva) and coherence.",
				"feedback": "Brilliant philosophical defense! You have demonstrated supreme mastery in Hetuvidya, dialectics, and the eternal Nalanda quest for truth."
			},
			{
				"id": "phil_opt_2",
				"text": "B) Accept the skeptic's position and declare that debate should be settled by roll of dice rather than reason.",
				"is_correct": false,
				"explanation": "Surrenders rationality and epistemological foundation.",
				"feedback": "Surrendering logic destroys the entire foundation of philosophical inquiry."
			},
			{
				"id": "phil_opt_3",
				"text": "C) Insult the visiting scholar's lineage and demand their expulsion from the university grounds.",
				"is_correct": false,
				"explanation": "Ad hominem fallacy violating the sacred code of Nalanda academic debate (Vada-maryada).",
				"feedback": "Personal attacks violate the ethical and rational standards of Nalanda debate."
			}
		],
		"exp_reward": 200
	}
}

static func get_chapter_data(chapter_id: String) -> Dictionary:
	match chapter_id.to_lower():
		"stupa":
			return CHAPTER_STUPA
		"library":
			return CHAPTER_LIBRARY
		"vihara":
			return CHAPTER_VIHARA
		_:
			return {}

static func get_final_mastery_scenario(domain: String) -> Dictionary:
	var dom = domain.to_lower().strip_edges()
	if "math" in dom or "ganita" in dom:
		return FINAL_MASTERY_SCENARIOS.get("mathematics", {})
	elif "astro" in dom or "jyotisha" in dom:
		return FINAL_MASTERY_SCENARIOS.get("astronomy", {})
	elif "med" in dom or "cikitsa" in dom or "ayurveda" in dom:
		return FINAL_MASTERY_SCENARIOS.get("medicine", {})
	elif "phil" in dom or "darsana" in dom or "nyaya" in dom or "hetuvidya" in dom:
		return FINAL_MASTERY_SCENARIOS.get("philosophy", {})
	return FINAL_MASTERY_SCENARIOS.get("mathematics", {})
