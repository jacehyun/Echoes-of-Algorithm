extends Area2D

var interaction_manager = null
var loot_panel = null
var player_in_range := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Find the nodes in your Level 1-1 scene
	interaction_manager = get_tree().current_scene.get_node("InteractionManager")
	loot_panel = get_tree().current_scene.get_node("CanvasLayer/LootPanel")

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = true
		if interaction_manager:
			interaction_manager.set_interactable(self)

func _on_body_exited(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		player_in_range = false
		if interaction_manager:
			interaction_manager.clear_interactable(self)

func interact() -> void:
	if player_in_range and loot_panel:
		interaction_manager.open_ui()
		loot_panel.open_panel()
		
		# Optional: Hide the scroll from the floor once the player opens it!
		self.visible = false
		var collision = get_node_or_null("CollisionShape2D")
		if collision:
			collision.set_deferred("disabled", true)
