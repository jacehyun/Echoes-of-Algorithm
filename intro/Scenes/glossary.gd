extends Node2D

func _ready() -> void:
	# Find the player and tell them to walk 200 pixels right from their spawn
	var player = get_node("Intro Player")
	if player:
		player.do_intro_walk_in()
