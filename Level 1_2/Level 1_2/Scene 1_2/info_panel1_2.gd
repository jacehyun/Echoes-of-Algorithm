extends Control


@onready var close_button = $Panel/CloseButton
@onready var ready_fight = $"../ReadyFight2"
@onready var camera: Camera2D = $"../../Camera2D"
@onready var sfx_roaming: AudioStreamPlayer2D = $"../../sfx_roaming"
@onready var sfx_warning: AudioStreamPlayer2D = $"../../sfx_warning"

var player = null
var interaction_manager = null

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_button_pressed)
	interaction_manager = get_tree().current_scene.get_node("InteractionManager")

func open_panel() -> void:
	visible = true
	
	
	if player and player.has_method("set_can_move"):
		player.set_can_move(false)

func close_panel() -> void:
	visible = false
	
	if player and player.has_method("set_can_move"):
		player.set_can_move(true)
	
	if interaction_manager:
		interaction_manager.close_ui()

func _on_close_button_pressed() -> void:
	close_panel()
	sfx_warning.play()
	ready_fight.visible = true
	
	if interaction_manager and interaction_manager.has_method("turn_off"):
		interaction_manager.turn_off()
	
	sfx_roaming.stop()
	
	if camera:
		shake_camera(camera, 4.0, 4.0)
		
	await get_tree().create_timer(2.5).timeout
	
	# 1. Spawn a black box using code and stretch it over the whole screen
	var fade_out_rect = ColorRect.new()
	fade_out_rect.color = Color(0, 0, 0, 0) # Start completely transparent
	fade_out_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Put it at the very top of the game so it covers everything
	get_tree().root.add_child(fade_out_rect) 
	
	# 2. Animate it to solid black over 1 second
	var fade_tween = create_tween()
	fade_tween.tween_property(fade_out_rect, "color:a", 1.0, 1.0)
	
	# 3. Wait for the screen to go 100% black BEFORE changing scenes
	await fade_tween.finished
	
	get_tree().change_scene_to_file("res://Level 1_2/Level 1_2/Scene 1_2/level_1_2.tscn")
	
func shake_camera(cam: Camera2D, duration: float, intensity: float) -> void:
	var shake_tween = create_tween()
	
	var shake_speed = 0.05
	var steps = int(duration / shake_speed)	
	
	for i in range(steps):
		var random_x = randf_range(-intensity, intensity)
		var random_y = randf_range(-intensity, intensity)
		
		shake_tween.tween_property(cam, "offset", Vector2(random_x, random_y), shake_speed)
		
	shake_tween.tween_property(cam, "offset", Vector2(0,0), shake_speed)	

#func _input(event: InputEvent) -> void:
	#if visible and event.is_action_pressed("ui_cancel"):
		#close_panel()
