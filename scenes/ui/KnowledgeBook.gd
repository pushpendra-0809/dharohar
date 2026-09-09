class_name KnowledgeBook
extends CanvasLayer

const KnowledgeBookData = preload("res://scripts/data/KnowledgeBookData.gd")

signal book_completed(domain_id: String)
signal book_closed()

@onready var dim_overlay: ColorRect = $DimOverlay
@onready var book_container: Control = $BookContainer
@onready var open_book_texture: TextureRect = $BookContainer/OpenBookTexture
@onready var left_page: Control = $BookContainer/LeftPage
@onready var right_page: Control = $BookContainer/RightPage
@onready var page_turn_anim: AnimatedSprite2D = $BookContainer/PageTurnAnimation

@onready var left_title_label: Label = $BookContainer/LeftPage/LeftTitle
@onready var left_subtitle_label: Label = $BookContainer/LeftPage/LeftSubtitle
@onready var left_narrative_label: Label = $BookContainer/LeftPage/LeftNarrative
@onready var left_quote_label: Label = $BookContainer/LeftPage/QuoteBox/LeftQuote

@onready var right_title_label: Label = $BookContainer/RightPage/RightTitle
@onready var right_points_label: RichTextLabel = $BookContainer/RightPage/RightPoints
@onready var right_insight_label: Label = $BookContainer/RightPage/InsightBox/RightInsight

@onready var page_indicator: Label = $BookContainer/PageIndicator
@onready var prev_button: Button = $BookContainer/PrevButton
@onready var next_button: Button = $BookContainer/NextButton
@onready var close_button: Button = $BookContainer/CloseButton

var _domain_id: String = ""
var _pages: Array = []
var _current_page_index: int = 0
var _is_animating: bool = false
var _is_open: bool = false
var _turn_direction: int = 1 # 1 for next, -1 for prev

const ANIM_FPS: float = 22.0

func _get_game_state() -> Node:
	if is_inside_tree() and get_tree().root:
		return get_tree().root.get_node_or_null("GameState")
	return null

func _ready() -> void:
	visible = false
	process_mode = PROCESS_MODE_ALWAYS
	if page_turn_anim:
		page_turn_anim.visible = false
	
	if prev_button and not prev_button.pressed.is_connected(_on_prev_pressed):
		prev_button.pressed.connect(_on_prev_pressed)
	if next_button and not next_button.pressed.is_connected(_on_next_pressed):
		next_button.pressed.connect(_on_next_pressed)
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	
static func open_book(parent: Node, domain_id: String, on_completed: Callable = Callable(), on_closed: Callable = Callable()) -> KnowledgeBook:
	var scene := load("res://scenes/ui/KnowledgeBook.tscn")
	if not scene:
		push_error("KnowledgeBook: Could not load scene res://scenes/ui/KnowledgeBook.tscn")
		return null
		
	var kb = scene.instantiate() as KnowledgeBook
	if parent:
		parent.add_child(kb)
	else:
		var root = Engine.get_main_loop() as SceneTree
		if root and root.root:
			root.root.add_child(kb)
			
	if on_completed.is_valid():
		kb.book_completed.connect(func(d):
			on_completed.call(d)
			if is_instance_valid(kb):
				kb.queue_free()
		)
	if on_closed.is_valid():
		kb.book_closed.connect(func():
			on_closed.call()
			if is_instance_valid(kb):
				kb.queue_free()
		)
		
	kb.open_knowledge_book(domain_id)
	return kb

func _unhandled_input(event: InputEvent) -> void:
	if _is_open:
		if event.is_action_pressed("pause") or event.is_action_pressed("escape") or (event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE):
			get_viewport().set_input_as_handled()
			close_knowledge_book()

func is_open() -> bool:
	return _is_open

func open_knowledge_book(domain_id: String) -> void:
	_domain_id = domain_id
	_pages = KnowledgeBookData.get_pages(domain_id)
	_current_page_index = 0
	_is_animating = false
	_is_open = true
	
	if _pages.is_empty():
		push_warning("KnowledgeBook: No pages found for domain: " + domain_id + ". Falling back to completed.")
		book_completed.emit(_domain_id)
		return
		
	var gs := _get_game_state()
	if gs and gs.has_method("lock_player_movement"):
		gs.lock_player_movement()
		
	visible = true
	_render_page_instant(_current_page_index)
	_animate_open()

func close_knowledge_book() -> void:
	if not _is_open:
		return
	_is_open = false
	_animate_close()

var _open_close_tween: Tween = null

func _animate_open() -> void:
	if _open_close_tween and _open_close_tween.is_valid():
		_open_close_tween.kill()
		
	if dim_overlay:
		dim_overlay.modulate = Color(1, 1, 1, 0)
	if book_container:
		book_container.modulate = Color(1, 1, 1, 0)
		book_container.scale = Vector2(0.92, 0.92)
		book_container.pivot_offset = book_container.size / 2.0
		
	_open_close_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if dim_overlay:
		_open_close_tween.tween_property(dim_overlay, "modulate:a", 1.0, 0.25)
	if book_container:
		_open_close_tween.tween_property(book_container, "modulate:a", 1.0, 0.25)
		_open_close_tween.tween_property(book_container, "scale", Vector2(1.0, 1.0), 0.25)

func _animate_close() -> void:
	if _open_close_tween and _open_close_tween.is_valid():
		_open_close_tween.kill()
		
	_open_close_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	if dim_overlay:
		_open_close_tween.tween_property(dim_overlay, "modulate:a", 0.0, 0.2)
	if book_container:
		_open_close_tween.tween_property(book_container, "modulate:a", 0.0, 0.2)
		_open_close_tween.tween_property(book_container, "scale", Vector2(0.94, 0.94), 0.2)
		
	_open_close_tween.chain().tween_callback(func():
		visible = false
		var gs := _get_game_state()
		if gs and gs.has_method("unlock_player_movement"):
			gs.unlock_player_movement()
		book_closed.emit()
	)

func _render_page_instant(page_idx: int) -> void:
	if page_idx < 0 or page_idx >= _pages.size():
		return
		
	var p: Dictionary = _pages[page_idx]
	
	# Left Page
	if left_title_label:
		left_title_label.text = str(p.get("left_title", "")).to_upper()
	if left_subtitle_label:
		left_subtitle_label.text = str(p.get("left_subtitle", ""))
	if left_narrative_label:
		left_narrative_label.text = str(p.get("left_narrative", ""))
	if left_quote_label:
		left_quote_label.text = "\"" + str(p.get("left_quote", "")) + "\""
		
	# Right Page
	if right_title_label:
		right_title_label.text = str(p.get("right_title", "")).to_upper()
		
	if right_points_label:
		var pts: Array = p.get("right_points", [])
		var pts_bbcode := ""
		for pt in pts:
			pts_bbcode += str(pt) + "\n\n"
		right_points_label.text = pts_bbcode.strip_edges()
		
	if right_insight_label:
		right_insight_label.text = str(p.get("right_insight", ""))
		
	# Page indicator
	if page_indicator:
		page_indicator.text = "— Page " + str(page_idx + 1) + " of " + str(_pages.size()) + " —"
		
	# Navigation buttons
	if prev_button:
		prev_button.disabled = (page_idx == 0)
		prev_button.visible = (page_idx > 0)
		
	if next_button:
		if page_idx >= _pages.size() - 1:
			next_button.text = "I AM READY ✦"
		else:
			next_button.text = "NEXT ▶"

func _on_next_pressed() -> void:
	if _is_animating:
		return
		
	if _current_page_index >= _pages.size() - 1:
		# Final page reached & player confirmed "I AM READY"
		_is_open = false
		var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		if dim_overlay:
			tween.tween_property(dim_overlay, "modulate:a", 0.0, 0.2)
		if book_container:
			tween.tween_property(book_container, "modulate:a", 0.0, 0.2)
			tween.tween_property(book_container, "scale", Vector2(0.95, 0.95), 0.2)
			
		tween.chain().tween_callback(func():
			visible = false
			book_completed.emit(_domain_id)
		)
		return
		
	_turn_page(1)

func _on_prev_pressed() -> void:
	if _is_animating or _current_page_index <= 0:
		return
	_turn_page(-1)

func _turn_page(direction: int) -> void:
	var target_idx := _current_page_index + direction
	if target_idx < 0 or target_idx >= _pages.size():
		return
		
	_current_page_index = target_idx
	_render_page_instant(_current_page_index)

func _on_close_pressed() -> void:
	close_knowledge_book()
