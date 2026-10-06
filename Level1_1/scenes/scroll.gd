extends Area2D

var interaction_manager = null
var info_panel = null
var player_in_range := false
var player_ref = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	interaction_manager = get_tree().current_scene.get_node("InteractionManager")
	info_panel = get_tree().current_scene.get_node("CanvasLayer/InfoPanel")

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = true
		player_ref = body
		interaction_manager.set_interactable(self)

func _on_body_exited(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = false
		player_ref = null
		interaction_manager.clear_interactable(self)

func interact() -> void:
	if player_in_range and info_panel:
		interaction_manager.open_ui()
		# Only send the player reference to lock movement
		info_panel.open_panel()
