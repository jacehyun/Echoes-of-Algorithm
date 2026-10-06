extends Node2D


@onready var interaction_prompt: Label = $"../CanvasLayer/InteractionPrompt"

var current_interactable = null
var is_ui_open := false
var is_active := true 

func _ready() -> void:
	interaction_prompt.visible = false

func set_interactable(interactable) -> void:
	if not is_active: return
	if not is_ui_open:
		current_interactable = interactable
		interaction_prompt.visible = true

func clear_interactable(interactable) -> void:
	if current_interactable == interactable:
		current_interactable = null
		interaction_prompt.visible = false

func open_ui() -> void:
	if not is_active: return
	is_ui_open = true
	interaction_prompt.visible = false

func close_ui() -> void:
	if not is_active: return
	is_ui_open = false
	if current_interactable:
		interaction_prompt.visible = true
		
func turn_off() -> void:
	is_active = false
	current_interactable = null
	interaction_prompt.visible = false

func _input(event: InputEvent) -> void:
	if not is_active: return
	if event.is_action_pressed("interact") and current_interactable and not is_ui_open:
		current_interactable.interact()
