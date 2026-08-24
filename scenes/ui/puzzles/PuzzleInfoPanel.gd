class_name PuzzleInfoPanel
extends Control

@onready var dim_rect: ColorRect = $DimRect
@onready var main_panel: Panel = $MainPanel
@onready var title_label: Label = $MainPanel/TitleLabel
@onready var subtitle_label: Label = $MainPanel/SubtitleLabel
@onready var rules_container: VBoxContainer = $MainPanel/MarginContainer/RulesVBox
@onready var disclaimer_label: Label = $MainPanel/DisclaimerLabel
@onready var close_button: Button = $MainPanel/CloseButton

var rules_db: Dictionary = {
	"math": {
		"title": "NALANDA NUMBER CHALLENGE — RULES",
		"rules": [
			"1. Read the mathematical question carefully.",
			"2. Use the number and operator tiles to construct your answer.",
			"3. Select the tiles in the correct order.",
			"4. Press SUBMIT when you are ready.",
			"5. If your answer is incorrect, review your calculation and try again.",
			"6. Use RESET to clear your current answer."
		],
		"disclaimer": ""
	},
	"medicine": {
		"title": "HERBAL DIAGNOSIS — RULES",
		"rules": [
			"1. Read the case and study the clues carefully.",
			"2. Examine the available herb cards.",
			"3. Select the herbs that best match the clues.",
			"4. Selected herbs will appear in the selection area.",
			"5. Press SUBMIT when you are ready.",
			"6. If your answer is incorrect, review the clues and try again.",
			"7. Use RESET to clear your selections."
		],
		"disclaimer": "Note: This is a fictional educational puzzle inspired by historical herbal knowledge and is not medical advice."
	},
	"astronomy": {
		"title": "NALANDA SKY WATCH — RULES",
		"rules": [
			"1. Observe the stars and read the clues carefully.",
			"2. Identify the stars that belong to the required pattern.",
			"3. Select or connect the correct stars.",
			"4. Use the clues to reconstruct the target pattern.",
			"5. Press SUBMIT when you are ready.",
			"6. Use RESET to clear your current star connections.",
			"7. If you are stuck, use HINT."
		],
		"disclaimer": ""
	},
	"philosophy": {
		"title": "DEBATE OF IDEAS — RULES",
		"rules": [
			"1. Read the philosophical question carefully.",
			"2. Study the claim and the available arguments.",
			"3. Choose the argument that best supports the claim.",
			"4. Read the counterargument carefully.",
			"5. Choose the response that best addresses the counterargument.",
			"6. Press SUBMIT when you are ready.",
			"7. If your answer is incorrect, reconsider the reasoning and try again."
		],
		"disclaimer": ""
	},
	"logic": {
		"title": "THE THREE SCHOLARS — RULES",
		"rules": [
			"1. Read the scenario and all the clues carefully.",
			"2. Use the clues to determine where each scholar belongs.",
			"3. Mark possibilities and eliminate choices that cannot be true.",
			"4. Use the deduction grid to construct your final solution.",
			"5. Press SUBMIT when you are ready.",
			"6. If your answer is incorrect, review the clues and adjust the grid.",
			"7. Use RESET to clear the grid."
		],
		"disclaimer": ""
	}
}

func _ready() -> void:
	visible = false
	if close_button and not close_button.pressed.is_connected(hide_info):
		close_button.pressed.connect(hide_info)

func show_info(domain_key: String) -> void:
	var key: String = domain_key.to_lower()
	if not rules_db.has(key):
		key = "math"
		
	var data: Dictionary = rules_db[key]
	
	if title_label:
		title_label.text = data.get("title", "RULES")
	if subtitle_label:
		subtitle_label.text = "HOW TO PLAY"
		
	if rules_container:
		for child in rules_container.get_children():
			child.queue_free()
			
		var r_list: Array = data.get("rules", [])
		for rule_text in r_list:
			var lbl: Label = Label.new()
			lbl.text = rule_text
			lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lbl.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78, 1.0))
			lbl.add_theme_font_size_override("font_size", 14)
			rules_container.add_child(lbl)
			
	if disclaimer_label:
		var disc: String = data.get("disclaimer", "")
		disclaimer_label.text = disc
		disclaimer_label.visible = (disc != "")
		
	visible = true

func hide_info() -> void:
	visible = false
