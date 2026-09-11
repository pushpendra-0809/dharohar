class_name ViharaObjectiveHUD
extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var held_item_label: Label = $PanelContainer/MarginContainer/VBox/HeldItemLabel
@onready var task1_lbl: Label = $PanelContainer/MarginContainer/VBox/Task1Label
@onready var task2_lbl: Label = $PanelContainer/MarginContainer/VBox/Task2Label
@onready var task3_lbl: Label = $PanelContainer/MarginContainer/VBox/Task3Label
@onready var task4_lbl: Label = $PanelContainer/MarginContainer/VBox/Task4Label
@onready var task5_lbl: Label = $PanelContainer/MarginContainer/VBox/Task5Label

@onready var dev_info_btn: Button = get_node_or_null("PanelContainer/MarginContainer/VBox/HeaderHBox/DevInfoBtn")
@onready var guide_modal: Control = get_node_or_null("GuideModal")
@onready var btn_close_modal: Button = get_node_or_null("GuideModal/Panel/Margin/VBox/TopBar/BtnCloseModal")
@onready var btn_bottom_close: Button = get_node_or_null("GuideModal/Panel/Margin/VBox/BtnBottomClose")

var _is_guide_open: bool = false

func _ready() -> void:
	add_to_group("vihara_objective_hud")
	visible = true
	
	if guide_modal:
		guide_modal.visible = false
		
	if dev_info_btn:
		dev_info_btn.pressed.connect(_on_info_btn_pressed)
		
	if btn_close_modal:
		btn_close_modal.pressed.connect(close_guide)
	if btn_bottom_close:
		btn_bottom_close.pressed.connect(close_guide)
		
	_check_dev_mode_status()

func _process(_delta: float) -> void:
	_check_dev_mode_status()

func _check_dev_mode_status() -> void:
	var dev_active: bool = false
	var dmm = get_node_or_null("/root/DevModeManager")
	if dmm and "dev_mode_enabled" in dmm:
		dev_active = dmm.dev_mode_enabled
			
	if dev_info_btn:
		dev_info_btn.visible = dev_active

func _on_info_btn_pressed() -> void:
	open_guide()

func open_guide() -> void:
	_is_guide_open = true
	if guide_modal:
		guide_modal.visible = true
	if GameState and GameState.has_method("lock_player_movement"):
		GameState.lock_player_movement()

func close_guide() -> void:
	_is_guide_open = false
	if guide_modal:
		guide_modal.visible = false
	if GameState and GameState.has_method("unlock_player_movement"):
		GameState.unlock_player_movement()

func _unhandled_input(event: InputEvent) -> void:
	if _is_guide_open and event is InputEventKey and event.is_pressed() and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			close_guide()

func update_tasks(t1: bool, t2: bool, t3: bool, t4: bool, t5: bool, carrying: String) -> void:
	if held_item_label:
		if carrying != "":
			var deliver_hint = ""
			if "Oil Lamp" in carrying or "lamp" in carrying.to_lower():
				deliver_hint = " ➔ Deliver to [East Study Desk]"
			elif "Manuscript" in carrying or "granth" in carrying.to_lower():
				deliver_hint = " ➔ Deliver to [Top-Right Scholar]"
			elif "Water" in carrying or "vessel" in carrying.to_lower():
				deliver_hint = " ➔ Place at [Center Courtyard Stand]"
			elif "Writing" in carrying or "kit" in carrying.to_lower():
				deliver_hint = " ➔ Deliver to [Bottom-Right Junior Desk]"
			held_item_label.text = "🎒 CARRYING: " + carrying + deliver_hint
			held_item_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		else:
			held_item_label.text = "🎒 CARRYING: (Hands free — Visit any pickup depot)"
			held_item_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
			
	_format_task(task1_lbl, "1. Light Study Lamps 🪔 [Top-Left Depot ➔ East Desk]", t1)
	_format_task(task2_lbl, "2. Astronomy Manuscript 📜 [Left Scribe ➔ Top-Right Scholar]", t2)
	_format_task(task3_lbl, "3. Water Vessels 🏺 [Bottom-Left Helper ➔ Center Stand]", t3)
	_format_task(task4_lbl, "4. Junior Study Space ✍️ [West Shelf ➔ Bottom-Right Desk]", t4)
	
	var all_prep = t1 and t2 and t3 and t4
	if t5:
		_format_task(task5_lbl, "5. Evening Bell 🔔 [Rung — Vihara Complete!]", true)
	elif all_prep:
		task5_lbl.text = "🔔 [ ] 5. Ring Evening Bell! [Ready at Top Shrine]"
		task5_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	else:
		task5_lbl.text = "🔒 [ ] 5. Evening Bell 🔔 [Top Shrine — Complete 1–4 first]"
		task5_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))

func _format_task(lbl: Label, task_text: String, is_done: bool) -> void:
	if not lbl:
		return
	if is_done:
		lbl.text = "✓ " + task_text
		lbl.add_theme_color_override("font_color", Color(0.45, 0.95, 0.45))
	else:
		lbl.text = "[ ] " + task_text
		lbl.add_theme_color_override("font_color", Color(0.9, 0.85, 0.75))
