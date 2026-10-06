extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 260.0
var direction: int = 1

func _ready() -> void:
	animated_sprite_2d.play("fly")
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

func set_direction(dir: int) -> void:
	direction = dir
	
	# flip sprite depende sa direction
	if direction < 0:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)

func _on_animation_finished() -> void:
	queue_free()
