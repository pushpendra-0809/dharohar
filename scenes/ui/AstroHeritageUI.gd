class_name AstroHeritageUI
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
		"title": "THE NIGHT SKY",
		"content": "Astronomy was closely connected with:\n\n• Timekeeping\n• Calendars\n• Seasons\n• Celestial observation\n• Mathematics",
		"teacher": "Long before modern tools, scholars studied the Sun, Moon, planets, and stars to measure time, seasons, and natural cycles."
	},
	{
		"title": "JYOTIṢA — THE STUDY OF THE HEAVENS",
		"content": "Jyotiṣa connected:\n\nObservation + Calculation + Time",
		"teacher": "Jyotiṣa was the classical study of observing and calculating celestial events to understand time and create calendars."
	},
	{
		"title": "NUMBERS AND THE HEAVENS",
		"content": "Mathematics helped scholars study:\n\n• Celestial movements\n• Time\n• Angles\n• Calendars\n• Planetary positions",
		"teacher": "Astronomy and mathematics were deeply linked. Calculations of angles and numbers helped determine planetary positions and measure time."
	},
	{
		"title": "ARYABHATA — THE MATHEMATICIAN OF THE STARS",
		"content": "Aryabhata worked on:\n\n• Arithmetic\n• Geometry\n• Algebraic methods\n• Trigonometry\n• Astronomy",
		"teacher": "Aryabhata (5th–6th century CE) composed the Āryabhaṭīya in 499 CE, uniting mathematics and astronomy during Nalanda's golden era."
	},
	{
		"title": "VARĀHAMIHIRA — OBSERVING THE COSMOS",
		"content": "His scholarly interests included:\n\n• Astronomy\n• Mathematics\n• Calendrical knowledge\n• Natural observations",
		"teacher": "Varāhamihira (6th century CE) combined astronomy, mathematics, and natural science into systematic works."
	},
	{
		"title": "MEASURING TIME",
		"content": "The sky helped scholars understand:\n\nDay → Month → Season → Year",
		"teacher": "Celestial movements provided key reference points for timekeeping, calendars, and agricultural seasons."
	},
	{
		"title": "MEASURING THE HEAVENS",
		"content": "Observation required:\n\n• Shadows\n• Angles\n• Directions\n• Time\n• Measurement",
		"teacher": "Scholars built simple instruments to measure shadows, solar positions, angles, and time passage."
	},
	{
		"title": "ASTRONOMY IN THE AGE OF NALANDA",
		"content": "Nalanda's wider scholarly world included:\n\n• Mathematics\n• Astronomy\n• Medicine\n• Philosophy\n• Logic\n• Debate and reasoning",
		"teacher": "At Nalanda, students studied astronomy alongside math, medicine, and philosophy through debate and observation."
	},
	{
		"title": "OBSERVE • CALCULATE • UNDERSTAND",
		"content": "OBSERVE → MEASURE → CALCULATE → REASON → UNDERSTAND",
		"teacher": "Patience is key: first observe, then measure and calculate, and finally reason to reveal patterns."
	},
	{
		"title": "WHAT YOU HAVE LEARNED",
		"content": "• Ancient Indian scholars carefully observed the heavens.\n• Jyotiṣa included traditions of astronomical observation and calculation.\n• Astronomy was closely connected with mathematics.\n• Aryabhata was a major mathematician-astronomer of the classical period.\n• Varāhamihira was another important scholar of astronomy and related sciences.\n• Celestial observations were connected with calendars and timekeeping.\n• Astronomy formed part of the wider intellectual world of the age in which Nalanda flourished.",
		"teacher": "The heavens were meant to be measured, calculated, and understood. Let us test your knowledge!"
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
		card_counter_label.text = "ASTRONOMY LESSON " + str(idx + 1) + " / " + str(cards.size())
		
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
