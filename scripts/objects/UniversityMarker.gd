extends Node2D

@onready var marker_container: Node2D = $MarkerContainer

func _ready() -> void:
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
	_update_visibility()

func _on_quest_state_changed() -> void:
	_update_visibility()

func _update_visibility() -> void:
	var is_revealed: bool = false
	if GameState:
		is_revealed = (GameState.university_location_revealed or GameState.nalanda_location_revealed)
	
	visible = is_revealed
