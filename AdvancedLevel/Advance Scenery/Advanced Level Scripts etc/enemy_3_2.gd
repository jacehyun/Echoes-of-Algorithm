extends CharacterBody2D

signal enemy_died
@onready var sfx_level_cleared: AudioStreamPlayer2D = $"../Sfx_levelCleared"

# ==============================
# CONSTANTS
# ==============================

const SPEED = 130.0
const ATTACK_STOP_DISTANCE = 30.0
const POSITION_TOLERANCE = 4.0
const ATTACK_DURATION = 0.6

# ==============================
# NODE REFERENCES
# ==============================
@onready var level_cleared = $"../CanvasLayer/LevelCleared"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_box = $DialogueBox
@onready var dialogue_label = $DialogueBox/Label

func show_dialogue(text: String) -> void:
	dialogue_label.text = text
	dialogue_box.visible = true
	
	await get_tree().create_timer(3.0).timeout

	dialogue_box.visible = false

# ==============================
# ENEMY STATE VARIABLES
# ==============================

var is_hit := false
var is_doing_attack_sequence := false
var is_using_attack := false

var sequence_start_x := 0.0
var player: Node2D = null

# ==============================
# READY
# ==============================

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	
	# Default idle animation
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Idle 3_2")

# ==============================
# HIT REACTION
# ==============================

func take_hit() -> void:
	if is_hit:
		return
	
	is_hit = true
	
	# Play hit animation
	animated_sprite_2d.play("Getting Hit 3_2")
	animated_sprite_2d.modulate = Color(1, 0, 0, 1)
	
	await get_tree().create_timer(0.6).timeout
	
	animated_sprite_2d.modulate = Color(1, 1, 1, 1)
	animated_sprite_2d.play("Idle 3_2")
	is_hit = false

# ==============================
# MAIN ENEMY ATTACK SEQUENCE
# ==============================

func start_attack_sequence() -> void:
	if is_doing_attack_sequence:
		return
	if player == null:
		return
	
	is_doing_attack_sequence = true
	sequence_start_x = global_position.x
	
	await move_to_attack_position()
	play_attack_animation()
	
	if not is_inside_tree(): return
	await get_tree().create_timer(0.3).timeout
	
	# Damage player
	if player and player.has_method("take_hit"):
		player.take_hit()
	
	if not is_inside_tree(): return
	
	await get_tree().create_timer(0.3).timeout
	is_using_attack = false
	
	await move_back_to_start()
	
	is_doing_attack_sequence = false

# ==============================
# ATTACK ANIMATION
# ==============================

func play_attack_animation() -> void:
	is_using_attack = true
	velocity.x = 0
	
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Attacking 3_2")

# ==============================
# MOVE TO PLAYER
# ==============================

func move_to_attack_position() -> void:
	if player == null:
		return
	
	var target_x = player.global_position.x + ATTACK_STOP_DISTANCE
	
	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		if not is_inside_tree(): return 
		
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED
		
		# Flip sprite based on direction
		animated_sprite_2d.flip_h = dir > 0
		
		if animated_sprite_2d.animation != "Walking 3_2":
			animated_sprite_2d.play("Walking 3_2")
		
		await get_tree().physics_frame
	
	velocity.x = 0
	global_position.x = target_x
	animated_sprite_2d.flip_h = false

# ==============================
# RETURN TO START
# ==============================

func move_back_to_start() -> void:
	var target_x = sequence_start_x
	
	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		if not is_inside_tree(): return 
		
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED
		
		animated_sprite_2d.flip_h = dir > 0
		
		if animated_sprite_2d.animation != "Walking 3_2":
			animated_sprite_2d.play("Walking 3_2")
		
		await get_tree().physics_frame
	
	velocity.x = 0
	global_position.x = target_x
	
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Idle 3_2")

# ==============================
# DEATH
# ==============================

func play_death_animation() -> void:
	velocity.x = 0
	is_doing_attack_sequence = false
	is_using_attack = false
	
	enemy_died.emit()
	is_hit = true
	
	animated_sprite_2d.play("Dying 3_2")
	
	await animated_sprite_2d.animation_finished
	
	visible = false
	await get_tree().create_timer(3.0).timeout
	
	level_cleared.visible = true
	sfx_level_cleared.play()
	await sfx_level_cleared.finished
	
	queue_free()

# ==============================
# PHYSICS
# ==============================

func _physics_process(delta: float) -> void:
	if is_doing_attack_sequence or is_using_attack:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
