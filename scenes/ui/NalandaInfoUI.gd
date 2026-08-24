extends CanvasLayer

signal info_closed()

var current_card_index: int = 0
var cards: Array[Dictionary] = []

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var card_counter_label: Label = $PanelContainer/CardCounterLabel
@onready var card_title_label: Label = $PanelContainer/TitleLabel
@onready var card_subtitle_label: Label = $PanelContainer/SubtitleLabel
@onready var card_content_label: Label = $PanelContainer/ContentLabel
@onready var onscreen_box: Panel = $PanelContainer/OnscreenBox
@onready var onscreen_label: Label = $PanelContainer/OnscreenBox/OnscreenLabel
@onready var teacher_box: Panel = $PanelContainer/TeacherBox
@onready var teacher_label: Label = $PanelContainer/TeacherBox/TeacherLabel
@onready var prev_button: Button = $PanelContainer/PrevButton
@onready var next_button: Button = $PanelContainer/NextButton
@onready var close_button: Button = $PanelContainer/CloseButton
@onready var top_close_button: Button = $PanelContainer/TopCloseButton

const NalandaInfoDataScript = preload("res://scripts/data/NalandaInfoData.gd")

func _ready() -> void:
	add_to_group("nalanda_info_ui")
	cards = NalandaInfoDataScript.CARDS
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false

	if prev_button and not prev_button.pressed.is_connected(_on_prev_pressed):
		prev_button.pressed.connect(_on_prev_pressed)
	if next_button and not next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.connect(_on_next_pressed)
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	if top_close_button and not top_close_button.pressed.is_connected(_on_close_pressed):
		top_close_button.pressed.connect(_on_close_pressed)

func open_info(start_idx: int = 0, p_cards: Array[Dictionary] = []) -> void:
	if p_cards.size() > 0:
		cards = p_cards
	elif cards.size() == 0:
		cards = NalandaInfoDataScript.CARDS

	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	_toggle_quest_ui(false)
	current_card_index = clamp(start_idx, 0, cards.size() - 1)
	if GameState:
		GameState.lock_player_movement()
		
	_load_card(current_card_index)

func close_info() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	_toggle_quest_ui(true)
	if GameState:
		GameState.unlock_player_movement()
	info_closed.emit()

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
		card_counter_label.text = "CARD " + str(idx + 1) + " / " + str(cards.size())
		
	if card_title_label:
		card_title_label.text = c_data.get("title", "")
		
	if card_subtitle_label:
		var sub: String = c_data.get("subtitle", "")
		card_subtitle_label.text = sub
		card_subtitle_label.visible = (sub != "")
		
	if card_content_label:
		card_content_label.text = c_data.get("content", "")
		
	if onscreen_box and onscreen_label:
		var onscr: String = c_data.get("onscreen", "")
		if onscr != "":
			onscreen_label.text = onscr
			onscreen_box.visible = true
		else:
			onscreen_box.visible = false
			
	if teacher_box and teacher_label:
		var t_quote: String = c_data.get("teacher", "")
		if t_quote != "":
			teacher_label.text = "SILABHADRA: \"" + t_quote + "\""
			teacher_box.visible = true
		else:
			teacher_box.visible = false
			
	if prev_button:
		prev_button.visible = (idx > 0)
		
	if next_button:
		if idx == cards.size() - 1:
			next_button.text = "CLOSE"
		else:
			next_button.text = "NEXT →"

func _on_next_pressed() -> void:
	if current_card_index < cards.size() - 1:
		current_card_index += 1
		_load_card(current_card_index)
	else:
		close_info()

func _on_prev_pressed() -> void:
	if current_card_index > 0:
		current_card_index -= 1
		_load_card(current_card_index)

func _on_close_pressed() -> void:
	close_info()

func _unhandled_input(event: InputEvent) -> void:
	if not visible or not panel_container or not panel_container.visible:
		return
		
	if event.is_action_pressed("ui_left") or (event is InputEventKey and event.is_pressed() and not event.is_echo() and (event.keycode == KEY_A or event.physical_keycode == KEY_A)):
		if current_card_index > 0:
			get_viewport().set_input_as_handled()
			_on_prev_pressed()
	elif event.is_action_pressed("ui_right") or (event is InputEventKey and event.is_pressed() and not event.is_echo() and (event.keycode == KEY_D or event.physical_keycode == KEY_D)):
		get_viewport().set_input_as_handled()
		_on_next_pressed()
	elif event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.is_pressed() and not event.is_echo() and (event.keycode == KEY_ESCAPE or event.physical_keycode == KEY_ESCAPE)):
		get_viewport().set_input_as_handled()
		close_info()
