class_name ViharaObjectiveHUD
extends CanvasLayer

@onready var panel: PanelContainer = get_node_or_null("PanelContainer")
@onready var held_item_label: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/HeldItemLabel")
@onready var task1_lbl: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/Task1Label")
@onready var task2_lbl: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/Task2Label")
@onready var task3_lbl: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/Task3Label")
@onready var task4_lbl: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/Task4Label")
@onready var task5_lbl: Label = get_node_or_null("PanelContainer/MarginContainer/VBox/Task5Label")

@onready var info_btn: Button = get_node_or_null("InfoBtn")
@onready var guide_modal: Control = get_node_or_null("GuideModal")
@onready var tasks_rich_label: RichTextLabel = get_node_or_null("GuideModal/Panel/Margin/VBox/Scroll/ContentVBox/TasksLabel")
@onready var btn_close_modal: Button = get_node_or_null("GuideModal/Panel/Margin/VBox/TopBar/BtnCloseModal")
@onready var btn_bottom_close: Button = get_node_or_null("GuideModal/Panel/Margin/VBox/BtnBottomClose")

var _is_guide_open: bool = false
var _last_t1: bool = false
var _last_t2: bool = false
var _last_t3: bool = false
var _last_t4: bool = false
var _last_t5: bool = false
var _last_carrying: String = ""

func _ready() -> void:
	add_to_group("vihara_objective_hud")
	visible = true
	
	if panel:
		panel.visible = false
		
	if guide_modal:
		guide_modal.visible = false
		
	if info_btn:
		info_btn.pressed.connect(_on_info_btn_pressed)
		_setup_btn_hover(info_btn)
		
	if btn_close_modal:
		btn_close_modal.pressed.connect(close_guide)
	if btn_bottom_close:
		btn_bottom_close.pressed.connect(close_guide)

func _setup_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	btn.mouse_entered.connect(func():
		var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(btn, "scale", Vector2(1.12, 1.12), 0.1)
	)
	btn.mouse_exited.connect(func():
		var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
	)

func _process(_delta: float) -> void:
	if info_btn:
		info_btn.visible = not _is_modal_active()

func _is_modal_active() -> bool:
	if _is_guide_open or (guide_modal and guide_modal.visible):
		return true
	var dev = get_node_or_null("/root/DevModeManager")
	if dev and "is_menu_open" in dev and dev.is_menu_open:
		return true
	var popup_groups := [
		"pause_menu", "pause_menu_ui", "vihara_challenge_ui", "vihara_completion_ui",
		"confirmation_dialog"
	]
	for g in popup_groups:
		var nodes = get_tree().get_nodes_in_group(g)
		for n in nodes:
			if is_instance_valid(n) and n.visible:
				return true
	return false

func _on_info_btn_pressed() -> void:
	open_guide()

func open_guide() -> void:
	_is_guide_open = true
	if guide_modal:
		guide_modal.visible = true
	_refresh_guide_tasks()
	if GameState and GameState.has_method("lock_player_movement"):
		GameState.lock_player_movement()

func close_guide() -> void:
	_is_guide_open = false
	if guide_modal:
		guide_modal.visible = false
	if GameState and GameState.has_method("unlock_player_movement"):
		GameState.unlock_player_movement()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.echo:
		if event.keycode == KEY_I or event.keycode == KEY_O:
			get_viewport().set_input_as_handled()
			if _is_guide_open:
				close_guide()
			else:
				open_guide()
			return
			
	if _is_guide_open and event is InputEventKey and event.is_pressed() and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			close_guide()

func update_tasks(t1: bool, t2: bool, t3: bool, t4: bool, t5: bool, carrying: String) -> void:
	_last_t1 = t1
	_last_t2 = t2
	_last_t3 = t3
	_last_t4 = t4
	_last_t5 = t5
	_last_carrying = carrying
	
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
		
	_refresh_guide_tasks()

func _refresh_guide_tasks() -> void:
	if not tasks_rich_label:
		return
		
	var c_hint = "[color=#aaaaaa]🎒 CARRYING: Hands free (Visit any pickup depot)[/color]"
	if _last_carrying != "":
		c_hint = "[color=#ffd700][b]🎒 CARRYING: " + _last_carrying + "[/b][/color]"
		
	var s1 = "[color=#44ff44]✓ 1. Light Study Lamps (Completed)[/color]" if _last_t1 else "[color=#ffaa44]🪔 1. Light the Study Lamps[/color]\n• Go to [b]Oil Lamps Depot[/b] (Top-Left) → Pick up brass oil lamp.\n• Deliver to [b]Study Room Desk[/b] (East room) for Student Jinamitra."
	var s2 = "[color=#44ff44]✓ 2. Deliver Astronomy Manuscript (Completed)[/color]" if _last_t2 else "[color=#ffaa44]📜 2. Deliver Astronomy Manuscript[/color]\n• Go to [b]Senior Scribe Bodhiruchi[/b] (Left side) → Pick up manuscript.\n• Deliver to [b]Astronomy Scholar Varaha[/b] (Top-Right cell)."
	var s3 = "[color=#44ff44]✓ 3. Arrange Water Vessels (Completed)[/color]" if _last_t3 else "[color=#ffaa44]🏺 3. Arrange Water Vessels[/color]\n• Go to [b]Water Helper[/b] (Bottom-Left) → Pick up fresh water vessels.\n• Place on [b]Courtyard Water Stand[/b] (Center courtyard)."
	var s4 = "[color=#44ff44]✓ 4. Prepare Junior Study Space (Completed)[/color]" if _last_t4 else "[color=#ffaa44]✍️ 4. Prepare Junior Study Space[/color]\n• Go to [b]Writing Supplies Shelf[/b] (West corridor) → Pick up writing board & ink.\n• Deliver to [b]Junior Student Desk[/b] (Bottom-Right room) for Student Soma."
	
	var s5 = ""
	if _last_t5:
		s5 = "[color=#44ff44]✓ 5. Evening Bell (Rung — Vihara Complete!)[/color]"
	elif (_last_t1 and _last_t2 and _last_t3 and _last_t4):
		s5 = "[color=#ffd700][b]🔔 5. Ring the Evening Bell (Ready!)[/b][/color]\n• All preparation complete! Ring the [b]Evening Bell[/b] at Top Shrine."
	else:
		s5 = "[color=#888888]🔒 5. Evening Bell (Sandhya Ghanta)[/color]\n• Complete preparation tasks 1–4 first to unlock."

	tasks_rich_label.text = "[color=#ffd700][b]TASKS & LOCATIONS:[/b][/color]\n" + c_hint + "\n\n" + s1 + "\n\n" + s2 + "\n\n" + s3 + "\n\n" + s4 + "\n\n" + s5

func _format_task(lbl: Label, task_text: String, is_done: bool) -> void:
	if not lbl:
		return
	if is_done:
		lbl.text = "✓ " + task_text
		lbl.add_theme_color_override("font_color", Color(0.45, 0.95, 0.45))
	else:
		lbl.text = "[ ] " + task_text
		lbl.add_theme_color_override("font_color", Color(0.9, 0.85, 0.75))
