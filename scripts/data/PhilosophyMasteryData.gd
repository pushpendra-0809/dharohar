class_name PhilosophyMasteryData
extends RefCounted

# ==============================================================================
# DHAROHAR 1.0 — PHILOSOPHY MASTERY (3 LEVELS)
# ==============================================================================
# Level 1: The Scholar's Claim (Interactive Argument Board: Claim, Reason, Evidence, Conclusion)
# Level 2: The Counterargument (Spot Problematic Assumptions & Build Sound Responses)
# Level 3: The Final Debate (Comprehensive Grand Scholarly Assembly)
# ==============================================================================

const LEVELS: Array[Dictionary] = [
	{
		"id": "scholars_claim",
		"level_number": 1,
		"title": "The Scholar's Claim",
		"nav_label": "1. The Scholar's Claim",
		"subtitle": "Level 1 of 3 — The Structure of a Sound Argument",
		"instructions": "Examine the scrambled statements on the scholar's desk. Click a statement to pick it up, then place it into its proper role on the Argument Board (Claim, Reason, Evidence, or Conclusion).",
		"completion_quote": "A sound argument is like a sturdy building: the claim is the roof, the reason is the pillar, evidence is the foundation, and conclusion is the shelter it provides.",
		"puzzles": [
			{
				"title": "Debate I: The Value of Open Discussion",
				"context": "A student in the courtyard is preparing an argument to show why scholars at Nalanda must discuss and debate manuscripts together rather than studying solely in isolation.",
				"target_roles": {
					"claim": "c1_claim",
					"reason": "c1_reason",
					"evidence": "c1_evidence",
					"conclusion": "c1_conclusion"
				},
				"cards": [
					{
						"id": "c1_reason",
						"text": "Discussion helps students examine different points of view and expose hidden assumptions."
					},
					{
						"id": "c1_conclusion",
						"text": "Therefore, open discussion and dialogue are essential practices for genuine learning."
					},
					{
						"id": "c1_claim",
						"text": "Students should regularly discuss and examine ideas with one another."
					},
					{
						"id": "c1_evidence",
						"text": "A student often discovers a blind spot in their own understanding after hearing a peer explain the same passage."
					}
				],
				"explanation": "• CLAIM: 'Students should discuss ideas with one another.' (The core proposition)\n• REASON: 'Discussion helps students examine different points of view.' (The logical support)\n• EVIDENCE: 'A student discovers blind spots when listening to peers.' (Concrete observation)\n• CONCLUSION: 'Therefore, discussion is essential for learning.' (The deduced resolution)",
				"hint": "Start by identifying the central thesis (Claim). Then look for the 'because' statement (Reason), the concrete example (Evidence), and the final 'therefore' statement (Conclusion)."
			},
			{
				"title": "Debate II: Observation in Science",
				"context": "In the astronomy corridor, two apprentices are drafting an argument explaining why astronomers must verify old texts through direct sky observation (Pratyaksha).",
				"target_roles": {
					"claim": "c2_claim",
					"reason": "c2_reason",
					"evidence": "c2_evidence",
					"conclusion": "c2_conclusion"
				},
				"cards": [
					{
						"id": "c2_evidence",
						"text": "The length of a gnomon's midday shadow changes continuously across seasons, proving the shifting solar path."
					},
					{
						"id": "c2_claim",
						"text": "Scholars of astronomy must observe natural phenomena directly rather than relying solely on old texts."
					},
					{
						"id": "c2_conclusion",
						"text": "Therefore, direct perception (Pratyaksha) is an indispensable foundation of valid knowledge."
					},
					{
						"id": "c2_reason",
						"text": "Direct observation verifies whether the recorded calculations in ancient manuscripts match living reality."
					}
				],
				"explanation": "• CLAIM: 'Scholars must observe phenomena directly.' (Main proposition)\n• REASON: 'Direct observation verifies whether recorded calculations match reality.' (Why it is necessary)\n• EVIDENCE: 'The changing length of gnomon shadows across seasons.' (Verifiable empirical proof)\n• CONCLUSION: 'Therefore, direct perception is an indispensable foundation of knowledge.' (Final deduction)",
				"hint": "Identify the main rule being argued, why it is true, the gnomon shadow proof, and the ultimate concluding principle."
			},
			{
				"title": "Debate III: Steady Practice vs Rushed Effort",
				"context": "A manuscript scribe prepares a counsel for newly admitted novices about cultivating scholarly endurance and disciplined habits.",
				"target_roles": {
					"claim": "c3_claim",
					"reason": "c3_reason",
					"evidence": "c3_evidence",
					"conclusion": "c3_conclusion"
				},
				"cards": [
					{
						"id": "c3_conclusion",
						"text": "Therefore, disciplined consistency rather than last-minute urgency is the true path to scholarly mastery."
					},
					{
						"id": "c3_claim",
						"text": "Mastery of any discipline requires steady daily contemplation rather than rushed study before trials."
					},
					{
						"id": "c3_reason",
						"text": "Gradual contemplation allows subtle philosophical principles to settle deeply into memory and intellect."
					},
					{
						"id": "c3_evidence",
						"text": "A palm-leaf manuscript is inscribed stroke by stroke with patience; hasty pressure fractures the dry leaf."
					}
				],
				"explanation": "• CLAIM: 'Mastery requires steady daily contemplation.' (Core assertion)\n• REASON: 'Gradual contemplation allows subtle principles to settle into intellect.' (Logical justification)\n• EVIDENCE: 'Inscribing palm leaves requires patient strokes to avoid fracturing.' (Classical analogy & proof)\n• CONCLUSION: 'Therefore, disciplined consistency is the true path to mastery.' (Final deduction)",
				"hint": "Connect the claim of daily study to its intellectual reason, the palm-leaf inscription analogy, and the closing deduction."
			}
		]
	},
	{
		"id": "counterargument",
		"level_number": 2,
		"title": "The Counterargument",
		"nav_label": "2. The Counterargument",
		"subtitle": "Level 2 of 3 — Spotting Flawed Assumptions & Constructing Sound Refutations",
		"instructions": "Listen to the scholar's claim. Use the Argument Lens to pinpoint the problematic assumption, then choose the most sound and balanced counterargument from the available response cards.",
		"completion_quote": "To refute an opponent does not mean to shout them down. It means to gently illuminate the flaw in their premise so truth becomes clear to both.",
		"debates": [
			{
				"title": "Mini-Debate 1: Reading Volume vs True Comprehension",
				"scholar_name": "Scholar Somadeva",
				"claim_text": "\"A student who reads many manuscripts must understand more than a student who reads only a few. Therefore, reading speed and volume alone guarantee supreme wisdom.\"",
				"weakness_options": [
					{
						"id": "w1_correct",
						"text": "Assuming that high reading volume *always guarantees* comprehension, ignoring reflection and critical thinking.",
						"is_correct": true
					},
					{
						"id": "w1_wrong1",
						"text": "Assuming that manuscripts can only be read during morning hours.",
						"is_correct": false
					},
					{
						"id": "w1_wrong2",
						"text": "Believing that no student should ever read any manuscripts in the library.",
						"is_correct": false
					}
				],
				"response_options": [
					{
						"id": "r1_correct",
						"text": "Understanding depends not merely on the number of pages seen, but on how carefully the student analyzes, questions, and reflects upon what is written.",
						"is_correct": true
					},
					{
						"id": "r1_wrong1",
						"text": "Speed is the only measure of genius, so the fastest reader is without question the greatest master.",
						"is_correct": false
					},
					{
						"id": "r1_wrong2",
						"text": "Scholars should discard all books and rely only on intuition without reading anything.",
						"is_correct": false
					}
				],
				"explanation": "A strong philosophical argument cannot rely on the flawed assumption that quantity equals quality. Genuine comprehension (Jñāna) requires deep reflection (Manana) and critical inquiry, not mere rapid memorization."
			},
			{
				"title": "Mini-Debate 2: Seniority vs Valid Proof",
				"scholar_name": "Scholar Vridhadeva",
				"claim_text": "\"An elder scholar is invariably correct in every intellectual dispute because years of seniority alone are the absolute proof of truth.\"",
				"weakness_options": [
					{
						"id": "w2_correct",
						"text": "Equating chronological age with indisputable logical validity, disregarding evidence and sound reasoning.",
						"is_correct": true
					},
					{
						"id": "w2_wrong1",
						"text": "Assuming that debates must take place in an open courtyard.",
						"is_correct": false
					},
					{
						"id": "w2_wrong2",
						"text": "Claiming that younger students are never allowed to speak at Nalanda.",
						"is_correct": false
					}
				],
				"response_options": [
					{
						"id": "r2_correct",
						"text": "Truth in philosophy rests on valid epistemological proof (Pramāna) and consistent logic, which remains true regardless of the age or seniority of the speaker.",
						"is_correct": true
					},
					{
						"id": "r2_wrong1",
						"text": "Elder scholars should never be listened to under any circumstances.",
						"is_correct": false
					},
					{
						"id": "r2_wrong2",
						"text": "Seniority is completely evil and debates should only be judged by loudness.",
						"is_correct": false
					}
				],
				"explanation": "In Nyāya and classical Indian epistemology, the validity of a statement is established by means of knowledge (Pramāṇa)—perception, inference, and verified testimony—not by the social seniority of the person making the claim."
			},
			{
				"title": "Mini-Debate 3: Initial Errors vs Growth in Learning",
				"scholar_name": "Scholar Durmukha",
				"claim_text": "\"A student who makes a reasoning mistake during their first debate trial lacks intellectual capability and should never attempt debate again.\"",
				"weakness_options": [
					{
						"id": "w3_correct",
						"text": "Assuming that an initial error indicates permanent incapacity, ignoring that learning occurs through correction.",
						"is_correct": true
					},
					{
						"id": "w3_wrong1",
						"text": "Assuming that scholars only debate during the rainy season.",
						"is_correct": false
					},
					{
						"id": "w3_wrong2",
						"text": "Believing that debate is the only activity conducted at the university.",
						"is_correct": false
					}
				],
				"response_options": [
					{
						"id": "r3_correct",
						"text": "Encountering and diagnosing flawed reasoning is the primary method through which a scholar refines discernment and achieves mastery.",
						"is_correct": true
					},
					{
						"id": "r3_wrong1",
						"text": "No scholar has ever made an error in history, so beginners must be punished.",
						"is_correct": false
					},
					{
						"id": "r3_wrong2",
						"text": "Reasoning errors do not matter because all opinions are equally correct in debate.",
						"is_correct": false
					}
				],
				"explanation": "Dialectical inquiry treats mistakes as valuable milestones for intellectual refinement. Identifying fallacies (Hetvābhāsa) teaches a philosopher how to formulate flawless deductions in the future."
			}
		]
	},
	{
		"id": "final_debate",
		"level_number": 3,
		"title": "The Final Debate",
		"nav_label": "3. The Final Debate",
		"subtitle": "Level 3 of 3 — The Scholar's Assembly & Grand Synthesis",
		"instructions": "Step onto the debate floor before the Assembly of Acharyas. Analyze the opposing master's sweeping challenge, dissect their logic across each parameter, and formulate the ultimate synthesis.",
		"completion_quote": "You did not win the debate by speaking first. You observed the claim, examined the reasoning, questioned the weakness, and formed your own conclusion. That is the discipline of thought.",
		"scenario": {
			"title": "THE GRAND ASSEMBLY DEBATE AT NALANDA",
			"opponent_name": "Visiting Acharya Jayanta",
			"opponent_speech": "\"Scholars of Nalanda! You spend endless hours in discussion, debate, and questioning across math, medicine, and stars. But I contend: Only silent solitary contemplation leads to truth. Engaging in debate and testing ideas with others produces nothing but confusion, argumentativeness, and intellectual distraction. Therefore, all communal debate and dialogue should be permanently abolished!\"",
			"fields": [
				{
					"title": "1. What is the Opponent's Core Reason?",
					"options": [
						"A) Debate creates confusion and intellectual distraction instead of truth.",
						"B) Palm leaves are too expensive for writing debates.",
						"C) Solitary contemplation requires no food or water.",
						"D) Debates can only be held after midnight."
					],
					"correct": 0
				},
				{
					"title": "2. What is the Problematic Assumption / Weakness?",
					"options": [
						"A) Assuming all debate is contentious conflict, ignoring that rigorous dialogue clarifies doubts and exposes blind spots.",
						"B) Assuming that libraries do not contain enough manuscripts.",
						"C) Assuming students prefer studying mathematics over philosophy.",
						"D) Assuming that tea is required before entering the courtyard."
					],
					"correct": 0
				},
				{
					"title": "3. Construct Your Dialectical Counterargument:",
					"options": [
						"A) Friendly, disciplined inquiry (Vāda) subjects individual thoughts to rigorous peer testing, transforming personal bias into verified knowledge.",
						"B) Solitary thinkers should be banished from the university immediately.",
						"C) Anyone who dislikes debate is simply afraid of losing.",
						"D) Discussion is good only because it makes the day pass faster."
					],
					"correct": 0
				},
				{
					"title": "4. Formulate the Grand Philosophical Conclusion:",
					"options": [
						"A) Therefore, solitary contemplation and collaborative debate are complementary wings of wisdom: one deepens insight, while the other purifies and verifies it.",
						"B) Therefore, solitary thinking is useless and only loud public shouting produces truth.",
						"C) Therefore, all forms of study should be replaced with sports.",
						"D) Therefore, no conclusion can ever be reached in any inquiry."
					],
					"correct": 0
				}
			],
			"synthesis": {
				"summary": "Your thesis harmonizes internal reflection with external dialectical verification. By upholding the classical Nalanda principle of Vāda (friendly, truth-seeking debate), you demonstrated that logic is not an instrument of discord, but a torch that illuminates truth for all scholars."
			}
		}
	}
]

static func get_level_count() -> int:
	return LEVELS.size()

static func get_level(index: int) -> Dictionary:
	if index >= 0 and index < LEVELS.size():
		return LEVELS[index]
	return {}
