extends Control

func _on_start_button_pressed() -> void:
	# 1. Find the player in the scene
	# Since this is a UI child, we look at the root of the current scene
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	
	if player:
		# 2. Wait for the player to walk off-screen to the RIGHT
		await player.do_exit_sequence(true)
	
	# 3. Now change the scene
	get_tree().change_scene_to_file("res://intro/Scenes/MainMenu.tscn")


func _on_help_pressed() -> void:
	$Start_Panel.visible = false
	$Help.visible =  false
	$Help_Panel.visible = true


func _on_okay_pressed() -> void:
	$Help_Panel.visible = false
	$Help.visible = true
	$Start_Panel.visible = true
