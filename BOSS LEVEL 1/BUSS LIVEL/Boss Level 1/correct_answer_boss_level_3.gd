extends Control

@onready var ok_button = $CorrectAnsBox/Okay
@onready var next_question = $"../Question Panel Boss Level 4"
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
			await enemy.show_dialogue("GROOAAHH!")
			
	visible = false
	next_question.visible = true
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
