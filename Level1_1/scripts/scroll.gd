extends Area2D

@export var scroll_title := "Ancient Scroll"
@export_multiline var scroll_text := "This is the information written in the scroll."

var interaction_manager = null
var info_panel = null
var player_in_range = false
var player_ref = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	interaction_manager = get_tree().current_scene.get_node("InteractionManager")
	info_panel = get_tree().current_scene.get_node("CanvasLayer/InfoPanel")

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_in_range = true
		player_ref = body
		interaction_manager.set_interactable(self)

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_in_range = false
		player_ref = null
		interaction_manager.clear_interactable(self)

func interact() -> void:
	if not player_in_range:
		return
	
	if info_panel:
		interaction_manager.open_ui()
		info_panel.open_panel(scroll_title, scroll_text, player_ref)
