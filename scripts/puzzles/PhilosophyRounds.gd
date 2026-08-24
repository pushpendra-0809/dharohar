class_name PhilosophyRounds
extends Node

static func get_rounds() -> Array:
	return [
		{
			"id": 1,
			"title": "Value of Knowledge",
			"question": "What makes knowledge valuable?",
			"claim": "Knowledge is most valuable when it guides right action and benefits living beings.",
			"arguments": [
				"Because it helps one understand the world and act with wisdom.",
				"Because having many manuscripts makes a scholar famous.",
				"Because knowledge never changes regardless of context."
			],
			"correct_argument_index": 0,
			"counterargument": "Yet some argue that knowledge is valuable purely for its own sake, even if never applied.",
			"responses": [
				"Pure knowledge remains incomplete until tested and applied in life.",
				"Unapplied knowledge is superior to practical wisdom.",
				"Famous scholars do not need practical application."
			],
			"correct_response_index": 0,
			"hint": "Look for the argument and response that emphasize practical wisdom and application.",
			"explanation": "Ancient Nalanda scholars emphasized that true knowledge (Vidya) must culminate in compassionate action (Karuna)."
		},
		{
			"id": 2,
			"title": "Knowledge and Wisdom",
			"question": "Is having knowledge enough to make someone wise?",
			"claim": "Information alone is not wisdom; wisdom requires deep understanding and moral discernment.",
			"arguments": [
				"Wisdom arises when knowledge is combined with reflection and virtue.",
				"Memorizing all texts instantly makes a person wise.",
				"Wisdom is simply the total number of facts one remembers."
			],
			"correct_argument_index": 0,
			"counterargument": "A scholar who memorizes all scriptures knows more facts than anyone else.",
			"responses": [
				"Memorization without understanding is like a donkey carrying sandalwood—it knows the weight, not the fragrance.",
				"Fact memory is identical to moral wisdom.",
				"Reading faster replaces the need for reflection."
			],
			"correct_response_index": 0,
			"hint": "Distinguish between raw memorization and reflective understanding.",
			"explanation": "Nalanda masters taught that rote memorization without contemplation (Manana) cannot produce true wisdom."
		},
		{
			"id": 3,
			"title": "Truth and Belief",
			"question": "Should a belief be accepted simply because many people believe it?",
			"claim": "Truth must be established through reason and investigation, not majority opinion.",
			"arguments": [
				"Popular consensus can be mistaken; truth requires investigation and evidence.",
				"If a crowd believes something, it must be true.",
				"Investigating traditions is respectful only if we agree with the majority."
			],
			"correct_argument_index": 0,
			"counterargument": "When traditions are held by entire communities for generations, they should not be questioned.",
			"responses": [
				"Respecting tradition means examining its reason so truth shines clearly.",
				"Old traditions can never contain errors.",
				"Majority opinion is always infallible."
			],
			"correct_response_index": 0,
			"hint": "Focus on investigation and critical examination over mere popularity.",
			"explanation": "Scholars engaged in Tarka (logic and debate) to test claims against reason rather than blind tradition."
		},
		{
			"id": 4,
			"title": "Learning Through Questions",
			"question": "Why can asking questions be an important part of learning?",
			"claim": "Questioning clarifies doubts, exposes hidden assumptions, and deepens understanding.",
			"arguments": [
				"Questioning breaks illusions and leads to deeper clarity.",
				"Questions are useful only when the answer is already known.",
				"Asking questions shows that a scholar lacks intelligence."
			],
			"correct_argument_index": 0,
			"counterargument": "Constant questioning might cause confusion and undermine respect for teachers.",
			"responses": [
				"Sincere questioning guided by respect leads to genuine conviction, not confusion.",
				"Teachers prefer silent agreement over active learning.",
				"Confusion is avoided by never asking anything."
			],
			"correct_response_index": 0,
			"hint": "Select choices that highlight respectful inquiry as a path to conviction.",
			"explanation": "Nalanda's famous debate halls welcomed intense questioning to refine scholarly understanding."
		},
		{
			"id": 5,
			"title": "Action and Intention",
			"question": "When judging an action, should we consider only its result, or also the intention behind it?",
			"claim": "Intention forms the moral seed of an action, even though consequences also matter.",
			"arguments": [
				"Moral quality depends on the intention (Cetana) that motivates the deed.",
				"Only external physical results matter; thoughts are irrelevant.",
				"Good intentions excuse any harm caused without reflection."
			],
			"correct_argument_index": 0,
			"counterargument": "If an action causes harm, the well-meaning intention behind it does not undo the damage.",
			"responses": [
				"Wisdom requires both pure intention and thoughtful consideration of consequences.",
				"Intentions matter so much that consequences can be ignored.",
				"Harmful results prove that intentions never existed."
			],
			"correct_response_index": 0,
			"hint": "Balance pure intention with mindful responsibility for consequences.",
			"explanation": "Philosophers taught that intention (Cetana) shapes ethical karma, while wisdom ensures careful action."
		}
	]
