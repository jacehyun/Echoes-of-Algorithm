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
	
	# Enemy default facing = LEFT
	animated_sprite_2d.flip_h = false

# ==============================
# HIT REACTION
# ==============================

func take_hit() -> void:
	if is_hit:
		return
	
	is_hit = true
	animated_sprite_2d.modulate = Color(1, 0, 0, 1)
	
	await get_tree().create_timer(0.6).timeout
	
	animated_sprite_2d.modulate = Color(1, 1, 1, 1)
	is_hit = false

# ==============================
# MAIN ENEMY ATTACK SEQUENCE
# Walk left -> Attack -> Return right
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
	
	# Wait a bit so hit happens during the attack
	if not is_inside_tree(): return # Safety check
	await get_tree().create_timer(0.3).timeout
	
	# Damage the player
	if player and player.has_method("take_hit"):
		player.take_hit()
	
	# Safety check: Did hitting the player cause the scene to reload?
	if not is_inside_tree(): return 
	
	# Finish attack delay
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
	
	# Enemy attacks facing LEFT
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Skill")

# ==============================
# MOVE TOWARD PLAYER
# Enemy comes from right side, so moves LEFT
# ==============================

func move_to_attack_position() -> void:
	if player == null:
		return
	
	# Stop at the right side of the player
	var target_x = player.global_position.x + ATTACK_STOP_DISTANCE
	
	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		# Safety check: Stop looping if the scene restarted
		if not is_inside_tree(): return 
		
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED
		
		if dir < 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		
		await get_tree().physics_frame
	
	velocity.x = 0
	global_position.x = target_x
	animated_sprite_2d.flip_h = false

# ==============================
# RETURN TO ORIGINAL POSITION
# Enemy goes back to the right
# ==============================

func move_back_to_start() -> void:
	var target_x = sequence_start_x
	
	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		# Safety check: Stop looping if the scene restarted
		if not is_inside_tree(): return 
		
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED
		
		if dir < 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		
		await get_tree().physics_frame
	
	velocity.x = 0
	global_position.x = target_x
	
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Idle_Movement Right")
	
# ==============================
# THIS PLAYS THE DEATH ANIMATION
# ==============================
func play_death_animation() -> void:
	velocity.x = 0
	is_doing_attack_sequence = false
	is_using_attack = false
	
	enemy_died.emit()
	
	# optional: disable further hit reactions
	is_hit = true
	
	# play death animation
	animated_sprite_2d.play("Death")
	
	# wait until death animation finishes
	await animated_sprite_2d.animation_finished
	
	visible = false
	await get_tree().create_timer(3.0).timeout
	
	level_cleared.visible = true
	sfx_level_cleared.play()
	await sfx_level_cleared.finished
	# optional: hide or remove enemy after animation
	queue_free()
	
	

# ==============================
# PHYSICS
# ==============================

func _physics_process(delta: float) -> void:
	if is_doing_attack_sequence:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	if is_using_attack:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
