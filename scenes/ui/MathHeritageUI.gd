class_name MathHeritageUI
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
		"title": "GAṆITA — THE ART OF CALCULATION",
		"content": "In classical India, mathematics was known as Gaṇita. Scholars developed methods for arithmetic, geometry, algebra, measurement, and numerical calculation.\n\nMathematics was not studied in isolation. It was closely connected with astronomy, architecture, calendars, trade, and everyday measurement.",
		"teacher": "To the scholars of our tradition, numbers were tools for understanding the world."
	},
	{
		"title": "ARYABHATA",
		"content": "Aryabhata, who lived around the 5th–6th century CE, was one of the great mathematician-astronomers of classical India.\n\nHis famous work, the Āryabhaṭīya, composed in 499 CE, presented mathematical and astronomical ideas in a remarkably concise form. His work included arithmetic, geometry, algebraic methods, and trigonometric calculations.\n\nAryabhata belonged to the same broad period in which Nalanda flourished and became one of the most influential mathematical and astronomical scholars of classical India.",
		"teacher": "Aryabhata's Āryabhaṭīya (499 CE) established foundational principles of math and astronomy."
	},
	{
		"title": "BRAHMAGUPTA",
		"content": "Brahmagupta, who lived in the 7th century CE, made important advances in arithmetic and algebra.\n\nHis Brāhmasphuṭasiddhānta, written in 628 CE, included systematic rules involving zero, positive and negative numbers, and mathematical equations.",
		"teacher": "Brahmagupta developed systematic mathematical rules for zero and equations."
	},
	{
		"title": "NUMBERS AND THE HEAVENS",
		"content": "Mathematics and astronomy were closely connected in classical Indian scholarship.\n\nMathematical calculations helped scholars measure time, construct calendars, study celestial movements, and make astronomical calculations.",
		"teacher": "A scholar who studied the heavens required the precise language of mathematics."
	},
	{
		"title": "BHĀSKARA I",
		"content": "Bhaskara I, who lived in the 7th century CE, was an important mathematician and commentator associated with the tradition of Aryabhata.\n\nHis writings helped explain and preserve mathematical and astronomical ideas, including important work related to trigonometry.",
		"teacher": "Bhāskara I built upon Aryabhata's work, advancing trigonometry and astronomical commentary."
	},
	{
		"title": "MATHEMATICS IN THE AGE OF NALANDA",
		"content": "Nalanda flourished as a major centre of learning during a period when mathematics, astronomy, medicine, philosophy, and logic were developing across the Indian subcontinent.\n\nMathematical knowledge formed part of the wider scholarly tradition that connected calculation with astronomy, observation, measurement, and reasoning.",
		"teacher": "Nalanda was an intellectual beacon where mathematics, astronomy, medicine, and philosophy met."
	},
	{
		"title": "WHAT YOU LEARNED",
		"content": "• Gaṇita was an important mathematical tradition.\n• Aryabhata advanced mathematics and astronomy.\n• Brahmagupta developed important rules involving zero and numbers.\n• Mathematics and astronomy were closely connected.\n• Scholars built upon the work of earlier scholars.\n• Nalanda flourished within this wider intellectual tradition.",
		"teacher": "Now you know the mathematical heritage of Nalanda. Let us test your understanding!"
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
		card_counter_label.text = "HERITAGE LESSON " + str(idx + 1) + " / " + str(cards.size())
		
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
