extends Control
@onready var panel_2: Panel = $Panel2

var is_transitioning := false

func _ready() -> void:
	panel_2.visible = true

func _on_next_level_pressed() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	# Hide this Level Cleared panel instantly
	self.visible = false
	self.modulate.a = 0.0
	
	# Grab nodes from the main scene
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node_or_null("Player")
	var anim_sprite = current_scene.get_node_or_null("Player/AnimatedSprite2D")
	var touch_controls = current_scene.get_node_or_null("Control/TouchControls")
	var fade_screen = current_scene.get_node_or_null("CanvasLayer/FadeScreen")
	
	if touch_controls:
		touch_controls.visible = false
		
	# --- 1. PLAYER WALKING ANIMATION ---
	if player and anim_sprite:
		player.set_physics_process(false) # Lock player controls
		anim_sprite.play("Running-West")  # Play running animation
		
		var exit_tween = create_tween()
		var target_x = player.position.x + 300
		exit_tween.tween_property(player, "position:x", target_x, 2.0)
		
	# --- 2. FADE TO BLACK ANIMATION ---
	if fade_screen:
		fade_screen.visible = true
		
		# THE FIX: Reset modulate to transparent, then tween it to solid black!
		fade_screen.modulate.a = 0.0 
		
		var fade_tween = create_tween()
		fade_tween.tween_property(fade_screen, "modulate:a", 1.0, 2.0)
		
		# Pause the code right here until the screen is pitch black
		await fade_tween.finished
	else:
		# Backup timer just in case
		await get_tree().create_timer(2.0).timeout
		
		self.visible = false
		
	# --- 3. TELEPORT ---
	
			# Unlock Topic 1 in the Glossary!
	GameManager.finished_beginner_game = true
	SaveManager.save_flags(SaveManager.is_beginner_done(), SaveManager.is_intermediate_done(), true)
	get_tree().change_scene_to_file("res://intro/Scenes/Start.tscn")
