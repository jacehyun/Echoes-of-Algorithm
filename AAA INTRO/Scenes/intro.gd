extends Node2D
@onready var introbg: AudioStreamPlayer2D = $introbg

func _ready() -> void:
	introbg.play()
	# Find the player and tell them to walk 200 pixels right from their spawn
	var player = get_node("Intro Player")
	if player:
		player.do_story_walk_in()
		
#	MusicManager.play_track("res://intro/Assets/Music/xDeviruchi - Title Theme .wav")
