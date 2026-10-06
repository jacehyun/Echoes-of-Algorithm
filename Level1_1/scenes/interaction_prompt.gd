extends Label

@onready var prompt = $"../CanvasLayer/InteractionPrompt"

var current_interactable = null
var is_ui_open := false

func _ready() -> void:
	prompt.visible = false

func set_interactable(interactable) -> void:
	if is_ui_open:
		return
	
	current_interactable = interactable
	prompt.visible = true

func clear_interactable(interactable) -> void:
	if current_interactable == interactable:
		current_interactable = null
		prompt.visible = false

func open_ui() -> void:
	is_ui_open = true
	prompt.visible = false

func close_ui() -> void:
	is_ui_open = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current_interactable != null and not is_ui_open:
			current_interactable.interact()
