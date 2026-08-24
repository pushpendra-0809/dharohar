class_name MedHeritageUI
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
		"title": "THE KNOWLEDGE OF HEALING",
		"content": "Ancient medical knowledge involved:\n\n• Observation\n• Plants and herbs\n• Food and diet\n• The human body\n• Health and healing",
		"teacher": "Scholars studied health, the human body, plants, and environment to observe treatments and pass knowledge across generations."
	},
	{
		"title": "AYURVEDA — THE SCIENCE OF LIFE",
		"content": "AYURVEDA\n\nAyus = Life\nVeda = Knowledge",
		"teacher": "Ayurveda comes from Sanskrit: Ayus (life) and Veda (knowledge), developing over centuries to maintain well-being."
	},
	{
		"title": "CHARAKA — THE PHYSICIAN-SCHOLAR",
		"content": "Charaka Saṃhitā\n\nAssociated with:\n• Medicine\n• Health\n• Diet\n• Herbs\n• Observation",
		"teacher": "Charaka is associated with the Charaka Saṃhitā, a foundational text on medicine, diagnosis, diet, and observation."
	},
	{
		"title": "SUSHRUTA — THE SURGEON-SCHOLAR",
		"content": "Sushruta Saṃhitā\n\nKnown for discussions of:\n• Surgery\n• Anatomy\n• Medical instruments\n• Wounds\n• Procedures",
		"teacher": "Sushruta is associated with the Sushruta Saṃhitā, a pioneering text detailing surgery, anatomy, and medical procedures."
	},
	{
		"title": "THE KNOWLEDGE OF PLANTS",
		"content": "A scholar might observe:\n\n• Leaves\n• Roots\n• Seeds\n• Flowers\n• Fruits\n• Smell and appearance",
		"teacher": "Knowledge of herbs required careful identification of leaves, roots, seeds, and flowers in the natural world."
	},
	{
		"title": "OBSERVE BEFORE YOU CONCLUDE",
		"content": "OBSERVE → UNDERSTAND → COMPARE → CONCLUDE",
		"teacher": "Observation was key: practitioners analyzed signs, symptoms, and habits before reaching a conclusion."
	},
	{
		"title": "HEALTH AND THE ENVIRONMENT",
		"content": "Health was considered in relation to:\n\n• Food\n• Seasons\n• Environment\n• Daily habits\n• The individual",
		"teacher": "Medical traditions considered how food, seasons, daily habits, and environment influence well-being."
	},
	{
		"title": "MEDICINE IN THE INTELLECTUAL WORLD OF NALANDA",
		"content": "The wider scholarly world included:\n\n• Medicine\n• Philosophy\n• Logic\n• Mathematics\n• Astronomy\n• Languages and literature",
		"teacher": "At Nalanda, medicine was studied as part of a wider curriculum alongside philosophy, logic, and mathematics."
	},
	{
		"title": "FROM TEACHER TO TEXT",
		"content": "TEACH → STUDY → DISCUSS → RECORD → PASS ON",
		"teacher": "Medical knowledge grew through teaching, discussion, and texts, allowing scholars to build upon earlier ideas."
	},
	{
		"title": "WHAT YOU HAVE LEARNED",
		"content": "• Ayurveda represents a major Indian tradition of health and life.\n• Charaka is associated with the Charaka Saṃhitā.\n• Sushruta is associated with the Sushruta Saṃhitā and surgery.\n• Plants and herbs were central to medical learning.\n• Careful observation guided diagnosis.\n• Health was linked to food, seasons, and environment.\n• Medicine was part of Nalanda's broader intellectual world.",
		"teacher": "Medicine required observation, patience, and knowledge of nature. Let us see what you have remembered!"
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
		card_counter_label.text = "MEDICINE LESSON " + str(idx + 1) + " / " + str(cards.size())
		
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
