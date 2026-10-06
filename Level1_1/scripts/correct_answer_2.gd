#extends Control
#
#@onready var ok_button = $CorrectAnsBox/Okay
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#visible = false
	#ok_button.pressed.connect(_on_ok_button_pressed)
	#pass # Replace with function body.
#
#func _on_ok_button_pressed() -> void:
	#visible = false
	#
	#await get_tree().create_timer(0.5).timeout 
	#
	#var player = get_tree().current_scene.get_node("Player")
	#if player and player.has_method("play_skill_animation"):
		#player.play_skill_animation()
		
extends Control

@onready var ok_button = $Okay
@onready var next_question = $"../QuestionPanel3"
@onready var sfx_enemy: AudioStreamPlayer2D = $"../../Sfx_enemy"
func _ready() -> void:
	visible = false
	ok_button.pressed.connect(_on_ok_button_pressed)

func _on_ok_button_pressed() -> void:
	visible = false
	
	var player = get_tree().current_scene.get_node("Player")
	if player and player.has_method("do_skill_sequence"):
		await player.do_skill_sequence()
	
	sfx_enemy.play()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.has_method("show_dialogue"):
			await enemy.show_dialogue("SKREE!")
			
	visible = false
	next_question.visible = true
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
