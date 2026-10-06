extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assuming your button is a child of "Topic Buttons" and named "Topic 1"
	# Change the node path if your button is named differently!
	if GameManager.finished_beginner_game == false:
		$"Topic Buttons/Topic 1".disabled = true
		$"Topic Buttons/Topic 1".text = "Locked"
	else:
		$"Topic Buttons/Topic 1".disabled = false
		$"Topic Buttons/Topic 1".text = "Topic 1"


# ... your _process and _on_return_button_pressed functions stay exactly the same ...


func _on_topic_1_pressed() -> void:
	# Double-check that they are allowed to open it
	if GameManager.finished_beginner_game == true:
		$"Topic Buttons".visible = false
		$PanelContainer.visible = false
		$Topic1_Panel.visible = true
	else:
		print("Topic 1 is locked!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_button_pressed() -> void:
	# 1. Set the flag so Start.tscn knows we are coming from the back button
	GameManager.coming_from_back_button = true
	
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	
	if player:
		# 2. Wait for player to walk off-screen to the LEFT
		await player.do_exit_sequence(false)
	
	# 3. Go back to the Start scene
	get_tree().change_scene_to_file("res://intro/Scenes/MainMenu.tscn")
	
	


func _on_okay_pressed() -> void:
	$"Topic Buttons".visible = true
	$PanelContainer.visible = true
	$Topic1_Panel.visible = false
