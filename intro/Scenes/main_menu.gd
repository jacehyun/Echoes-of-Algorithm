extends Node2D
@onready var introbg: AudioStreamPlayer2D = $introbg

func _ready() -> void:
	introbg.play()
	var player = get_node("Intro Player") # Make sure this matches the name in your tree!
	if player:
		if GameManager.coming_from_back_button:
			player.position = Vector2(300, -16) # Start Right
			player.do_back_walk_in(26.0)
			GameManager.coming_from_back_button = false
		else:
			player.position = Vector2(-95, -16) # Start Left
			player.do_intro_walk_in(26.0)
