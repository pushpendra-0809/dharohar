class_name LogicHeritageUI
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
		"title": "THE ART OF REASONING",
		"content": "• Examine arguments\n• Identify reasons\n• Find contradictions\n• Draw conclusions\n• Test ideas",
		"teacher": "To study difficult ideas, scholars needed logic to distinguish strong arguments from weak ones."
	},
	{
		"title": "HETUVIDYA — THE STUDY OF REASONING",
		"content": "REASON → SUPPORTS → CONCLUSION",
		"teacher": "In Buddhist scholastic traditions, Hetuvidya was the study of logic to ensure conclusions were properly supported."
	},
	{
		"title": "FROM CLUES TO CONCLUSIONS",
		"content": "FACT + FACT + FACT → REASONING → CONCLUSION",
		"teacher": "Logical reasoning uses clues to eliminate false possibilities and understand why an answer must follow."
	},
	{
		"title": "NYAYA — REASONED INQUIRY",
		"content": "What is the evidence?\n\nHow does it support the conclusion?\n\nCould another explanation be possible?",
		"teacher": "The Nyaya tradition developed systematic approaches to evidence, inference, and reasoned inquiry."
	},
	{
		"title": "A CLAIM NEEDS SUPPORT",
		"content": "CLAIM + REASON + EVIDENCE → STRONGER ARGUMENT",
		"teacher": "A claim is not true simply because it is stated; it requires solid reasons and supporting evidence."
	},
	{
		"title": "ELIMINATING THE IMPOSSIBLE",
		"content": "MANY POSSIBILITIES → REMOVE WHAT CANNOT BE TRUE → FEWER POSSIBILITIES → LOGICAL CONCLUSION",
		"teacher": "Complex problems are often solved by systematically removing possibilities that cannot be true."
	},
	{
		"title": "REASONING IN DEBATE",
		"content": "LISTEN → EXAMINE → QUESTION → RESPOND",
		"teacher": "In debate, logicians examined opposing arguments to identify weaknesses and defend their own conclusions."
	},
	{
		"title": "DHARMAKIRTI — A GREAT LOGICIAN",
		"content": "Dharmakirti's logical work:\n\n• Perception\n• Inference\n• Knowledge\n• Reasoning\n• Argumentation",
		"teacher": "Dharmakirti was an influential Buddhist logician of classical India whose works on perception and inference shaped logic."
	},
	{
		"title": "REASONING AT NALANDA",
		"content": "LOGIC + PHILOSOPHY + DEBATE + KNOWLEDGE → REASONING",
		"teacher": "At Nalanda, logic provided the essential tool for examining philosophical claims and conducting debate."
	},
	{
		"title": "WHAT YOU HAVE LEARNED",
		"content": "• Logic was an important part of Indian intellectual traditions.\n• Hetuvidya was associated with reasoning and logical analysis.\n• Nyaya developed systematic approaches to reasoning, knowledge, and inference.\n• Strong arguments require reasons and supporting evidence.\n• Logical deduction can eliminate possibilities and lead to conclusions.\n• Logic supported philosophical discussion and scholarly debate.\n• Dharmakirti became an influential figure in Buddhist logic and philosophy.\n• Nalanda's scholarly environment encouraged reasoning, discussion, and examination of ideas.",
		"teacher": "A clever guess finds an answer, but a scholar explains why it must be correct. Let us test your logical reasoning!"
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
		card_counter_label.text = "LOGIC LESSON " + str(idx + 1) + " / " + str(cards.size())
		
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
