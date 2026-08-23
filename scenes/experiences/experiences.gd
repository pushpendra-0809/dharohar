extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") or event.is_action_pressed("ui_cancel") or event.is_action_pressed("back"):
		_on_back_pressed()

func _on_nalanda_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nalanda/nalanda.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")
