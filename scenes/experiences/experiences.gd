extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_nalanda_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/nalanda/Nalanda.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")
