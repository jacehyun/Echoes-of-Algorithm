extends Control

@onready var close_button = $CloseButton
@onready var level_cleared = $"../LevelCleared"
@onready var interaction_manager = $"../../InteractionManager"
@onready var player = $"../../Player"

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_button_pressed)

func open_panel() -> void:
	visible = true
	
	# Stop the player from moving while they are reading
	if player and player.has_method("set_can_move"):
		player.set_can_move(false)

func _on_close_button_pressed() -> void:
	visible = false
	
	# Free up the interaction manager
	if interaction_manager:
		interaction_manager.close_ui()
		
	# Trigger the Level Cleared screen!
	if level_cleared:
		level_cleared.visible = true
