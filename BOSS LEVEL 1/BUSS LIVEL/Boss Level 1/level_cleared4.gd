extends Control
@onready var panel_2: Panel = $Panel2

var is_transitioning := false

func _ready() -> void:
	panel_2.visible = true

func _on_next_level_pressed() -> void:
	if is_transitioning:
		return
	is_transitioning = true

	# ↓ Read from SaveManager BEFORE any await — avoids mobile file I/O timing issues
	var intermediate_done = SaveManager.is_intermediate_done()
	var advanced_done     = SaveManager.is_advanced_done()

	self.visible = false
	self.modulate.a = 0.0

	var current_scene  = get_tree().current_scene
	var player         = current_scene.get_node_or_null("Player")
	var anim_sprite    = current_scene.get_node_or_null("Player/AnimatedSprite2D")
	var touch_controls = current_scene.get_node_or_null("Control/TouchControls")
	var fade_screen    = current_scene.get_node_or_null("CanvasLayer/FadeScreen")

	if touch_controls:
		touch_controls.visible = false

	if player and anim_sprite:
		player.set_physics_process(false)
		anim_sprite.play("Running-West")
		var exit_tween = create_tween()
		exit_tween.tween_property(player, "position:x", player.position.x + 300, 2.0)

	if fade_screen:
		fade_screen.visible    = true
		fade_screen.modulate.a = 0.0
		var fade_tween = create_tween()
		fade_tween.tween_property(fade_screen, "modulate:a", 1.0, 2.0)
		await fade_tween.finished
	else:
		await get_tree().create_timer(2.0).timeout

	# ↓ Use cached values — no file reads after await
	GameManager.finished_beginner_game = true
	SaveManager.save_flags(true, intermediate_done, advanced_done)
	get_tree().change_scene_to_file("res://intro/Scenes/DifficultySelection.tscn")
