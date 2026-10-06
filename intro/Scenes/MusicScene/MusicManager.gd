extends Node

var bgm_player: AudioStreamPlayer

func _ready() -> void:
	# Just setup the player, don't play yet!
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
	bgm_player.bus = "Master"

# Create a function to play a specific track
func play_track(path: String):
	var stream = load(path)
	if bgm_player.stream != stream: # Don't restart if it's already playing
		bgm_player.stream = stream
		bgm_player.play()

func stop_music():
	if bgm_player:
		bgm_player.stop()
