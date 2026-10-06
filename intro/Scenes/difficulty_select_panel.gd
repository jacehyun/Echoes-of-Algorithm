extends Control

func _ready() -> void:
	_update_buttons()

func _update_buttons() -> void:
	var intermediate_btn = $DifficultySelectButton_Container/Intermediate_Button
	var advanced_btn     = $DifficultySelectButton_Container/Advanced_Button

	# Intermediate — greyed out visually but still clickable to show warning
	if SaveManager.is_beginner_done():
		intermediate_btn.modulate = Color(1, 1, 1, 1)    # full color — unlocked
	else:
		intermediate_btn.modulate = Color(0.5, 0.5, 0.5, 1)  # greyed — locked

	# Advanced — same treatment
	if SaveManager.is_intermediate_done():
		advanced_btn.modulate = Color(1, 1, 1, 1)
	else:
		advanced_btn.modulate = Color(0.5, 0.5, 0.5, 1)

func _on_beginner_button_pressed() -> void:
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)
	var saved_level = SaveManager.get_saved_level()
	if saved_level != "":
		print("Loading saved level: ", saved_level)
		get_tree().change_scene_to_file(saved_level)
	else:
		print("No save found, starting fresh.")
		get_tree().change_scene_to_file("res://AAA INTRO/Scenes/intro.tscn")

func _on_intermediate_button_pressed() -> void:
	# Check if locked — show warning instead
	if not SaveManager.is_beginner_done():
		$DifficultySelectButton_Container.visible = false
		$LevelLockWarning_Panel.visible = true
		return

	# Unlocked — proceed to intermediate
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)
	get_tree().change_scene_to_file("res://Intermediate Roaming/roaming_scene_int_1.tscn")

func _on_advanced_button_pressed() -> void:
	# Check if locked — show warning instead
	if not SaveManager.is_intermediate_done():
		$DifficultySelectButton_Container.visible = false
		$LevelLockWarning_Panel.visible = true
		return

	# Unlocked — proceed to advanced
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)
	get_tree().change_scene_to_file("res://Advanced Roaming/roaming_scene_adv_1.tscn")

func _on_okay_button_pressed() -> void:
	$LevelLockWarning_Panel.visible           = false
	$DifficultySelectButton_Container.visible = true

func _on_return_button_pressed() -> void:
	GameManager.coming_from_back_button = true
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(false)
	get_tree().change_scene_to_file("res://intro/Scenes/MainMenu.tscn")
