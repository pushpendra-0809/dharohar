class_name ControlsTutorialPlayer
extends Node

const TUTORIAL_UI_SCENE = preload("res://scenes/ui/ControlsTutorialUI.tscn")

static func show_tutorial(parent: Node, on_closed_callback: Callable = Callable()) -> CanvasLayer:
	if not parent or not is_instance_valid(parent):
		return null
		
	var tutorial_instance = TUTORIAL_UI_SCENE.instantiate()
	parent.add_child(tutorial_instance)
	
	if on_closed_callback.is_valid():
		tutorial_instance.tutorial_closed.connect(on_closed_callback, CONNECT_ONE_SHOT)
		
	tutorial_instance.show_popup()
	return tutorial_instance
