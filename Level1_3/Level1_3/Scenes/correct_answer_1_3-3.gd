extends Control

@onready var ok_button = $CorrectAnsBox/Okay
@onready var next_level = $"../LevelCleared"
@onready var sfx_enemy: AudioStreamPlayer2D = $"../../Sfx_enemy"

func _ready() -> void:
	visible = false
	ok_button.pressed.connect(_on_ok_button_pressed)

func _on_ok_button_pressed() -> void:
	visible = false
	
	# Player does skill sequence first
	var player = get_tree().current_scene.get_node("Player")
	if player and player.has_method("do_skill_sequence"):
		await player.do_skill_sequence()
	
	await get_tree().create_timer(0.0).timeout
	
	sfx_enemy.play()
	# Enemy dies after player attack
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.has_method("play_death_animation"):
			await enemy.play_death_animation()
	
	# Show next popup/panel
	next_level.visible = true
