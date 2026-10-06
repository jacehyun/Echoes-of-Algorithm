extends CharacterBody2D

# ==============================
# FOR THE UI HEALTH BAR
# ==============================
signal health_changed(new_health)
signal player_died

var max_health := 100
var current_health := 100

func _ready() -> void:
	current_health = max_health



# ==============================
# CONSTANTS
# ==============================

# Normal player movement speed
const SPEED = 130.0

# Jump force
const JUMP_VELOCITY = -300.0

# Distance where the player stops before the enemy
const SKILL_STOP_DISTANCE = 30.0

# Range where the skill can hit enemies
const SKILL_HIT_RANGE = 90.0

# Small allowance to prevent endless walk looping
const POSITION_TOLERANCE = 4.0


# ==============================
# NODE REFERENCES
# ==============================

# Reference to the player's sprite animation
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# ==============================
# PLAYER STATE VARIABLES
# ==============================

# Last facing direction (1 = right, -1 = left)
var last_direction := 1

# True while the skill animation is playing
var is_using_skill := false

# True while the whole skill sequence is happening
var is_doing_sequence := false

# Saves the starting position before the skill sequence begins
var sequence_start_x := 0.0

# Prevent repeated hit flash
var is_hit := false


# ==============================
# SKILL ANIMATION
# ==============================

func play_skill_animation() -> void:
	# Lock player movement
	is_using_skill = true
	velocity.x = 0

	# Face right while performing skill
	last_direction = 1
	animated_sprite_2d.flip_h = false

	# Play skill animation
	animated_sprite_2d.play("Skill")


# ==============================
# PLAYER HIT REACTION
# ==============================

func take_hit() -> void:
	if is_hit:
		return

	is_hit = true
	animated_sprite_2d.modulate = Color(1, 0, 0, 1)

	await get_tree().create_timer(0.6).timeout

	animated_sprite_2d.modulate = Color(1, 1, 1, 1)
	is_hit = false
	
	if current_health <= 0:
		return
	#damage taken per maling sagot
	current_health -= 34
	
	#updates changes to the health
	health_changed.emit(current_health)
	
	if current_health <= 0:
		die()
		
#DIE FUNCTION
func die() -> void:
	print("Gmae over")
	player_died.emit()


# ==============================
# FIND TARGET ENEMY
# ==============================

func get_target_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest_enemy: Node2D = null
	var nearest_distance := INF

	for enemy in enemies:
		if enemy == null:
			continue

		var distance = global_position.distance_to(enemy.global_position)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


# ==============================
# MAIN SKILL SEQUENCE
# Walk -> Skill -> Return
# ==============================

func do_skill_sequence() -> void:
	if is_doing_sequence:
		return

	var target_enemy = get_target_enemy()
	if target_enemy == null:
		return

	is_doing_sequence = true

	# Save starting position
	sequence_start_x = global_position.x

	# Step 1: Move near the enemy
	await move_to_skill_position(target_enemy)

	# Step 2: Perform skill
	play_skill_animation()

	# Step 3: Wait a bit, then hit the enemy
	await get_tree().create_timer(0.5).timeout
	hit_enemy_in_range()

	# Step 4: Wait for skill animation to finish
	await animated_sprite_2d.animation_finished

	# Step 5: Return to original position
	await move_back_to_start()

	is_doing_sequence = false


# ==============================
# DAMAGE ENEMIES
# ==============================

func hit_enemy_in_range() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")

	for enemy in enemies:
		if enemy == null:
			continue

		var distance = global_position.distance_to(enemy.global_position)

		if distance <= SKILL_HIT_RANGE:
			if enemy.has_method("take_hit"):
				enemy.take_hit()


# ==============================
# WALK TO ATTACK POSITION
# Player stops at the LEFT side of the enemy
# ==============================

func move_to_skill_position(enemy: Node2D) -> void:
	if enemy == null:
		return

	var target_x = enemy.global_position.x - SKILL_STOP_DISTANCE

	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED

		# Same flip logic as your player:
		# right = false, left = true
		if dir > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true

		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")

		await get_tree().physics_frame

	# Stop exactly at attack position
	velocity.x = 0
	global_position.x = target_x

	# Face right before attacking
	last_direction = 1
	animated_sprite_2d.flip_h = false


# ==============================
# RETURN TO ORIGINAL POSITION
# ==============================

func move_back_to_start() -> void:
	var target_x = sequence_start_x

	while abs(global_position.x - target_x) > POSITION_TOLERANCE:
		var dir = sign(target_x - global_position.x)
		velocity.x = dir * SPEED

		# Same flip logic as your player:
		# right = false, left = true
		if dir > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true

		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")

		await get_tree().physics_frame

	# Stop exactly at original position
	velocity.x = 0
	global_position.x = target_x

	# Face right after returning
	last_direction = 1
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Idle_Front")


# ==============================
# PLAYER MOVEMENT LOGIC
# ==============================

func _physics_process(delta: float) -> void:
	# If the skill sequence is happening,
	# ignore normal controls
	if is_doing_sequence:
		if not is_on_floor():
			velocity += get_gravity() * delta

		move_and_slide()
		return

	# If skill animation is playing,
	# block movement
	if is_using_skill:
		move_and_slide()
		return

	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement input
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * SPEED

		last_direction = 1 if direction > 0 else -1

		# Flip sprite based on direction
		animated_sprite_2d.flip_h = last_direction < 0

		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
	else:
		# Slow down when no input
		velocity.x = move_toward(velocity.x, 0, SPEED)

		animated_sprite_2d.flip_h = last_direction < 0

		if animated_sprite_2d.animation != "Idle_Front":
			animated_sprite_2d.play("Idle_Front")

	move_and_slide()


# ==============================
# SKILL ANIMATION FINISH
# ==============================

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "Skill":
		is_using_skill = false

# ==============================
# EXIT SCREEN SEQUENCE (Generic)
# ==============================
func do_exit_sequence(to_right: bool = true) -> void:
	is_doing_sequence = true
	var screen_width = get_viewport_rect().size.x
	var exit_speed = SPEED * 0.7

	while true:
		velocity.x = exit_speed if to_right else -exit_speed
		animated_sprite_2d.flip_h = !to_right
		
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		
		move_and_slide()
		await get_tree().physics_frame
		
		# THE BREAK CONDITION:
		if to_right and global_position.x > 225:
			break
		if !to_right and global_position.x < -100:
			break

	velocity.x = 0
	is_doing_sequence = false
	# Once this function hits this point, the 'await' in the UI script finishes!

# ==============================
# INTRO WALK-IN (FROM CURRENT POSITION)
# ==============================

# Change this line in intro_player.gd
func do_intro_walk_in(target_x: float = 26.0) -> void:
	is_doing_sequence = true
	var intro_speed = SPEED * 0.7

	while position.x < target_x:
		velocity.x = intro_speed
		animated_sprite_2d.flip_h = false
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		move_and_slide()
		await get_tree().physics_frame

	velocity.x = 0
	position.x = target_x # Ensures they stop exactly at 26
	animated_sprite_2d.play("Idle_Front")
	is_doing_sequence = false

# Also change this line in intro_player.gd
func do_back_walk_in(target_x: float = 26.0) -> void:
	is_doing_sequence = true
	var intro_speed = SPEED * 0.7

	while position.x > target_x:
		velocity.x = -intro_speed
		animated_sprite_2d.flip_h = true
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		move_and_slide()
		await get_tree().physics_frame

	velocity.x = 0
	position.x = target_x # Ensures they stop exactly at 26
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Idle_Front")
	is_doing_sequence = false


# ==============================
# INTRO WALK-IN (FROM CURRENT POSITION)
# ==============================

func do_story_walk_in() -> void:
	is_doing_sequence = true
	
	var start_x = global_position.x
	var target_x = start_x + 45.0
	
	# Create a walk speed that is 60% of your normal speed
	var intro_speed = SPEED * 0.7

	while global_position.x < target_x:
		# Use the slower intro_speed here
		velocity.x = intro_speed
		
		animated_sprite_2d.flip_h = false
		if animated_sprite_2d.animation != "Running-West":
			animated_sprite_2d.play("Running-West")
		
		move_and_slide()
		await get_tree().physics_frame

	velocity.x = 0
	animated_sprite_2d.play("Idle_Front")
	is_doing_sequence = false
