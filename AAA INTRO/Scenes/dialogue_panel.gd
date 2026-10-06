extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next1_pressed() -> void:
	$"Dialogue Panel 1".visible = false
	$"Dialogue Panel 2".visible = true


func _on_next2_pressed() -> void:
	$"Dialogue Panel 2".visible = false
	$"Dialogue Panel 3".visible = true


func _on_next3_pressed() -> void:
	$"Dialogue Panel 3".visible = false
	$"Dialogue Panel 4".visible = true


func _on_next4_pressed() -> void:
	$"Dialogue Panel 4".visible = false
	$"Dialogue Panel 5".visible = true


func _on_next5_pressed() -> void:
	$"Dialogue Panel 5".visible = false
	$"Dialogue Panel 6".visible = true


func _on_next6_pressed() -> void:
	# 1. Correct Path to the node in the Scene Tree
	var player = get_node("../../Intro Player")
	var music_node = get_node_or_null("../../MusicManager")
	
	if player:
		print("Button Clicked: Player starting walk...")
		
		# 2. Hide the UI
		self.visible = false 
		
	
		# 3. Wait for the walk to finish
		
		
		await player.do_exit_sequence()
		
		
		
		# 4. Change to your actual world scene
		get_tree().change_scene_to_file("res://Level1_1/scenes/roaming_scene.tscn") # Put your world path here
	else:
		print("Error: Could not find Intro Player node!")


func _on_return_button_pressed() -> void:
	# 1. Set the flag so Start.tscn knows we are coming from the back button
	GameManager.coming_from_back_button = true
	
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	
	if player:
		# 2. Wait for player to walk off-screen to the LEFT
		await player.do_exit_sequence(false)
	
	# 3. Go back to the Start scene
	get_tree().change_scene_to_file("res://intro/Scenes/MainMenu.tscn")
