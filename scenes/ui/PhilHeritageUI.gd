class_name PhilHeritageUI
extends CanvasLayer

signal heritage_completed()

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var title_label: Label = $PanelContainer/TitleLabel
@onready var subtitle_label: Label = $PanelContainer/SubtitleLabel
@onready var card_counter_label: Label = $PanelContainer/CardCounterLabel
@onready var card_title_label: Label = $PanelContainer/CardBox/CardTitleLabel
@onready var card_content_label: Label = $PanelContainer/CardBox/CardContentLabel
@onready var teacher_label: Label = $PanelContainer/TeacherBox/TeacherLabel
@onready var continue_button: Button = $PanelContainer/ContinueButton
@onready var back_button: Button = $PanelContainer/BackButton
@onready var skip_button: Button = $PanelContainer/SkipButton

var current_card_index: int = 0

var cards: Array = [
	{
		"title": "THE SEARCH FOR KNOWLEDGE",
		"content": "• Questioning\n• Studying\n• Discussing\n• Reasoning\n• Understanding",
		"teacher": "At Nalanda, learning meant studying ideas, asking questions, and seeking deeper understanding beyond mere facts."
	},
	{
		"title": "PHILOSOPHY — THE LOVE OF WISDOM",
		"content": "What is true?\n\nHow do we know?\n\nWhat is the nature of reality?\n\nHow should we live?",
		"teacher": "Indian philosophy explored deep questions about knowledge, reality, ethics, and existence through careful reasoning."
	},
	{
		"title": "DEBATE — LEARNING THROUGH DIALOGUE",
		"content": "PRESENT AN IDEA → LISTEN → QUESTION → REASON → RESPOND",
		"teacher": "Debate made learning an active process, requiring scholars to listen, question, and respond thoughtfully."
	},
	{
		"title": "MANY PATHS OF THOUGHT",
		"content": "• Reality\n• Knowledge\n• Consciousness\n• Suffering\n• Understanding",
		"teacher": "Nalanda was a major centre for Buddhist scholarship, where traditions like Madhyamaka and Yogacara were debated."
	},
	{
		"title": "A WORLD OF DIFFERENT IDEAS",
		"content": "• Reality\n• Knowledge\n• Consciousness\n• Ethics\n• Logic\n• Liberation",
		"teacher": "Students encountered diverse philosophical schools, learning that understanding disagreement is an important lesson."
	},
	{
		"title": "KNOWLEDGE IS NOT WISDOM",
		"content": "KNOWLEDGE + REFLECTION + REASONING → DEEPER UNDERSTANDING",
		"teacher": "A scholar may know many facts, but true wisdom requires reflection and reasoning rather than simple memorization."
	},
	{
		"title": "SHILABHADRA — THE SCHOLAR OF NALANDA",
		"content": "TEACHER → STUDENT → KNOWLEDGE → ACROSS CULTURES",
		"teacher": "Shilabhadra was a prominent teacher at Nalanda who famously instructed the Chinese pilgrim-scholar Xuanzang."
	},
	{
		"title": "XUANZANG — A STUDENT OF NALANDA",
		"content": "CHINA → INDIA → NALANDA → KNOWLEDGE → CHINA",
		"teacher": "The Chinese scholar Xuanzang studied philosophy at Nalanda under Shilabhadra, recording valuable historical accounts."
	},
	{
		"title": "ASK • QUESTION • UNDERSTAND",
		"content": "QUESTION → EXAMINE → COMPARE → REASON → UNDERSTAND",
		"teacher": "A good student questions assumptions and compares arguments rather than accepting ideas blindly."
	},
	{
		"title": "WHAT YOU HAVE LEARNED",
		"content": "• Philosophy explored questions about knowledge, reality, ethics, and existence.\n• Nalanda became a major centre of Buddhist philosophical scholarship.\n• Different schools and traditions developed different arguments.\n• Debate and questioning were important parts of intellectual learning.\n• Shilabhadra was a prominent scholar and teacher associated with Nalanda.\n• Xuanzang studied at Nalanda and recorded valuable observations about India.\n• Philosophical learning encouraged examination, reasoning, and deeper understanding.",
		"teacher": "A philosopher asks not just 'What is the answer?' but 'Why should I believe it?' Let us test your reasoning!"
	}
]

func _ready() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	if continue_button and not continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.connect(_on_continue_pressed)
	if back_button and not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)
	if skip_button and not skip_button.pressed.is_connected(_on_skip_pressed):
		skip_button.pressed.connect(_on_skip_pressed)

func open_heritage() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	_toggle_quest_ui(false)
	current_card_index = 0
	if GameState:
		GameState.lock_player_movement()
		
	_load_card(current_card_index)

func close_heritage() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	_toggle_quest_ui(true)
	if GameState:
		GameState.unlock_player_movement()

func _toggle_quest_ui(p_visible: bool) -> void:
	var q_ui = get_tree().get_first_node_in_group("quest_ui")
	if not q_ui:
		var root = get_tree().current_scene
		if root:
			q_ui = root.get_node_or_null("QuestUI")
	if q_ui:
		q_ui.visible = p_visible
		if p_visible and q_ui.has_method("update_quest_ui"):
			q_ui.update_quest_ui()

func _load_card(idx: int) -> void:
	if idx < 0 or idx >= cards.size():
		return
		
	var c_data: Dictionary = cards[idx]
	
	if card_counter_label:
		card_counter_label.text = "PHILOSOPHY LESSON " + str(idx + 1) + " / " + str(cards.size())
		
	if card_title_label:
		card_title_label.text = c_data.get("title", "")
		
	if card_content_label:
		card_content_label.text = c_data.get("content", "")
		
	if teacher_label:
		teacher_label.text = "SILABHADRA: \"" + c_data.get("teacher", "") + "\""
		
	if back_button:
		back_button.visible = (idx > 0)
		
	if continue_button:
		if idx == cards.size() - 1:
			continue_button.text = "START PREREQUISITES"
		else:
			continue_button.text = "CONTINUE"

func _on_continue_pressed() -> void:
	if current_card_index < cards.size() - 1:
		current_card_index += 1
		_load_card(current_card_index)
	else:
		close_heritage()
		heritage_completed.emit()

func _on_back_pressed() -> void:
	if current_card_index > 0:
		current_card_index -= 1
		_load_card(current_card_index)

func _on_skip_pressed() -> void:
	close_heritage()
	heritage_completed.emit()
