class_name DomainSelectionUI
extends CanvasLayer

signal domain_selected(domain_id: String)

@onready var container: Control = $SelectionBox
@onready var btn_math: Button = $SelectionBox/VBoxContainer/BtnMath
@onready var btn_astro: Button = $SelectionBox/VBoxContainer/BtnAstro
@onready var btn_med: Button = $SelectionBox/VBoxContainer/BtnMed
@onready var btn_phil: Button = $SelectionBox/VBoxContainer/BtnPhil

func _ready() -> void:
	container.visible = false
	btn_math.pressed.connect(func(): _on_select("mathematics"))
	btn_astro.pressed.connect(func(): _on_select("astronomy"))
	btn_med.pressed.connect(func(): _on_select("medicine"))
	btn_phil.pressed.connect(func(): _on_select("philosophy"))

func open_selection() -> void:
	GameState.lock_player_movement()
	container.visible = true

func close_selection() -> void:
	container.visible = false

func _on_select(domain_id: String) -> void:
	close_selection()
	domain_selected.emit(domain_id)
