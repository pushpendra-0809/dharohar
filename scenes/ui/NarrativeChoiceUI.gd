class_name NarrativeChoiceUI
extends CanvasLayer

signal chapter_resolved(chapter_id: String, choice_id: String)
signal ui_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var title_label: Label = $MainPanel/Header/TitleLabel
@onready var location_label: Label = $MainPanel/Header/LocationLabel
@onready var close_button: Button = $MainPanel/Header/CloseButton

# Investigation Phase
@onready var investigation_box: Control = $MainPanel/InvestigationBox
@onready var intro_text: RichTextLabel = $MainPanel/InvestigationBox/IntroText
@onready var clues_text: RichTextLabel = $MainPanel/InvestigationBox/CluesText
@onready var domain_insight_label: RichTextLabel = $MainPanel/InvestigationBox/DomainInsightLabel

# Choices Container
@onready var choices_container: VBoxContainer = $MainPanel/ChoicesContainer
@onready var btn_option_a: Button = $MainPanel/ChoicesContainer/OptionA
@onready var btn_option_b: Button = $MainPanel/ChoicesContainer/OptionB
@onready var btn_option_c: Button = $MainPanel/ChoicesContainer/OptionC

# Consequence Phase
@onready var consequence_box: Control = $MainPanel/ConsequenceBox
@onready var consequence_title: Label = $MainPanel/ConsequenceBox/ConsequenceTitle
@onready var consequence_text: RichTextLabel = $MainPanel/ConsequenceBox/ConsequenceText
@onready var reaction_text: RichTextLabel = $MainPanel/ConsequenceBox/ReactionText
@onready var btn_claim_scroll: Button = $MainPanel/ConsequenceBox/BtnClaimScroll

var current_chapter_data: Dictionary = {}
var current_chapter_id: String = ""
var selected_choice_id: String = ""
var is_open: bool = false
var _on_complete_callback: Callable = Callable()

func _ready() -> void:
	add_to_group("narrative_choice_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_button_events()

func _setup_button_events() -> void:
	if close_button and not close_button.pressed.is_connected(close_ui):
		close_button.pressed.connect(close_ui)
		
	if btn_option_a and not btn_option_a.pressed.is_connected(_on_choice_selected.bind(0)):
		btn_option_a.pressed.connect(_on_choice_selected.bind(0))
	if btn_option_b and not btn_option_b.pressed.is_connected(_on_choice_selected.bind(1)):
		btn_option_b.pressed.connect(_on_choice_selected.bind(1))
	if btn_option_c and not btn_option_c.pressed.is_connected(_on_choice_selected.bind(2)):
		btn_option_c.pressed.connect(_on_choice_selected.bind(2))
		
	if btn_claim_scroll and not btn_claim_scroll.pressed.is_connected(_on_claim_scroll_pressed):
		btn_claim_scroll.pressed.connect(_on_claim_scroll_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func open_chapter(chapter_id: String, on_complete: Callable = Callable()) -> void:
	current_chapter_id = chapter_id.to_lower().strip_edges()
	current_chapter_data = NarrativeMasteryData.get_chapter_data(current_chapter_id)
	_on_complete_callback = on_complete
	
	if current_chapter_data.is_empty():
		push_error("NarrativeChoiceUI: Invalid chapter id: " + str(chapter_id))
		return
		
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		
	_populate_chapter_ui()

func _populate_chapter_ui() -> void:
	if title_label:
		title_label.text = current_chapter_data.get("title", "Story Chapter")
	if location_label:
		location_label.text = "📍 " + current_chapter_data.get("location", "Nalanda Mahavihara")
		
	# 1. Setup Intro Dialogue / Situation
	if intro_text:
		var intro_lines: Array = current_chapter_data.get("intro", [])
		var formatted_intro: String = ""
		for step in intro_lines:
			var spk: String = step.get("speaker", "Scholar")
			var txt: String = step.get("text", "")
			formatted_intro += "[b]" + spk + ":[/b] \"" + txt + "\"\n"
		intro_text.text = formatted_intro
		
	# 2. Setup Clues
	if clues_text:
		var clues: Array = current_chapter_data.get("clues", [])
		var formatted_clues: String = "[b][u]INVESTIGATION CLUES & WITNESS TESTIMONY:[/u][/b]\n"
		for cl in clues:
			formatted_clues += cl + "\n"
		clues_text.text = formatted_clues
		
	# 3. Setup Domain Insight (Based on player's chosen domain!)
	if domain_insight_label:
		var domain_insights: Dictionary = current_chapter_data.get("domain_insights", {})
		var p_dom: String = GameState.selected_domain.to_lower().strip_edges() if GameState else "mathematics"
		var matched_key: String = "mathematics"
		if "astro" in p_dom or "jyotisha" in p_dom:
			matched_key = "astronomy"
		elif "med" in p_dom or "cikitsa" in p_dom or "ayurveda" in p_dom:
			matched_key = "medicine"
		elif "phil" in p_dom or "darsana" in p_dom or "nyaya" in p_dom or "hetuvidya" in p_dom:
			matched_key = "philosophy"
			
		var insight_str: String = domain_insights.get(matched_key, "")
		if insight_str != "":
			domain_insight_label.text = "[color=#ffd700][b]💡 " + insight_str + "[/b][/color]"
			domain_insight_label.visible = true
		else:
			domain_insight_label.visible = false
			
	# 4. Setup Choices
	var choices: Array = current_chapter_data.get("choices", [])
	if btn_option_a:
		btn_option_a.text = choices[0].get("text", "Choice A") if choices.size() > 0 else ""
		btn_option_a.visible = choices.size() > 0
	if btn_option_b:
		btn_option_b.text = choices[1].get("text", "Choice B") if choices.size() > 1 else ""
		btn_option_b.visible = choices.size() > 1
	if btn_option_c:
		btn_option_c.text = choices[2].get("text", "Choice C") if choices.size() > 2 else ""
		btn_option_c.visible = choices.size() > 2
		
	# Hide Consequence Box initially
	if investigation_box:
		investigation_box.visible = true
	if choices_container:
		choices_container.visible = true
	if consequence_box:
		consequence_box.visible = false

func _on_choice_selected(index: int) -> void:
	var choices: Array = current_chapter_data.get("choices", [])
	if index < 0 or index >= choices.size():
		return
		
	var choice: Dictionary = choices[index]
	selected_choice_id = choice.get("id", "choice_" + str(index))
	
	if investigation_box:
		investigation_box.visible = false
	if choices_container:
		choices_container.visible = false
		
	if consequence_box:
		consequence_box.visible = true
		
	if consequence_title:
		consequence_title.text = "DECISION OUTCOME & CONSEQUENCE"
	if consequence_text:
		consequence_text.text = "[b]Your Decision:[/b] " + choice.get("text", "") + "\n\n" + choice.get("consequence", "")
	if reaction_text:
		reaction_text.text = "[i]" + choice.get("reaction", "") + "[/i]"
		
	if btn_claim_scroll:
		var scroll_name: String = current_chapter_data.get("scroll_name", "Scroll of Wisdom")
		btn_claim_scroll.text = "📜 Claim " + scroll_name + " & Conclude"

func _on_claim_scroll_pressed() -> void:
	if GameState:
		match current_chapter_id:
			"stupa":
				GameState.complete_stupa_story_chapter(selected_choice_id)
			"library":
				GameState.complete_library_story_chapter(selected_choice_id)
			"vihara":
				GameState.complete_vihara_story_chapter(selected_choice_id)
				
	chapter_resolved.emit(current_chapter_id, selected_choice_id)
	
	var cb = _on_complete_callback
	close_ui()
	if cb.is_valid():
		cb.call()

func close_ui() -> void:
	is_open = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
	if GameState:
		GameState.unlock_player_movement()
	ui_closed.emit()
