extends Node2D

@onready var player = $Player
@onready var animated_sprite_2d: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var touch_controls: CanvasLayer = $Control/TouchControls
@onready var sfx_roaming: AudioStreamPlayer2D = $sfx_roaming

func _ready() -> void:
	player.set_physics_process(false)
	touch_controls.visible = false
	
	sfx_roaming.play()
	
	var final_position = player.position
	player.position.x -= 100
	
	animated_sprite_2d.play("Running-West")
	
	var tween = create_tween()
	
	tween.tween_property(player, "position", final_position, 1.5)
	
	tween.finished.connect(_on_entrance_finished)
	
func _on_entrance_finished() -> void:
	animated_sprite_2d.play("Idle_Movement Right")
	
	player.set_physics_process(true)
	
	
