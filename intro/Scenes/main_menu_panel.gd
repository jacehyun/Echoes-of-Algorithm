extends Control

const NewPlayer = preload("res://intro/Scenes/NewPlayer.tscn")
const LeaderboardPanel = preload("res://intro/Scenes/LeardearboardPanel.tscn")
const PlayerSelectPanel  = preload("res://intro/Scenes/PlayerSelectPanel.tscn")

func _ready() -> void:
	var continue_btn = $MainMenuButtons_Container/Continue_Button
	continue_btn.disabled = !SaveManager.has_save()
	if SaveManager.has_save():
		continue_btn.text = "Continue"  # no single name shown — multiple players possible

func _process(delta: float) -> void:
	pass

func _on_new_game_button_pressed() -> void:
	var dialog = NewPlayer.instantiate()
	get_tree().current_scene.add_child(dialog)
	var store = { "name": "", "done": false }
	dialog.name_confirmed.connect(func(n):
		store["name"] = n
		store["done"] = true
	, CONNECT_ONE_SHOT)
	dialog.cancelled.connect(func():
		store["done"] = true
	, CONNECT_ONE_SHOT)
	while not store["done"]:
		await get_tree().process_frame
	if store["name"] == "":
		return
	SaveManager.save_player_name(store["name"])
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)
	get_tree().change_scene_to_file("res://intro/Scenes/DifficultySelection.tscn")

func _on_continue_button_pressed() -> void:
	# Show player select panel
	var select = PlayerSelectPanel.instantiate()
	get_tree().current_scene.add_child(select)

	var store = { "name": "", "done": false, "new": false }
	select.player_selected.connect(func(n):
		store["name"] = n
		store["done"] = true
	, CONNECT_ONE_SHOT)
	select.new_player_requested.connect(func():
		store["new"]  = true
		store["done"] = true
	, CONNECT_ONE_SHOT)
	select.cancelled.connect(func():
		store["done"] = true
	, CONNECT_ONE_SHOT)

	while not store["done"]:
		await get_tree().process_frame

	# They want a new player — hand off to New Game flow
	if store["new"]:
		_on_new_game_button_pressed()
		return

	if store["name"] == "":
		return  # cancelled

	print("Welcome back, ", store["name"], "!")

	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)

	var saved_level = SaveManager.get_saved_level()
	if saved_level != "":
		get_tree().change_scene_to_file(saved_level)
	else:
		get_tree().change_scene_to_file("res://intro/Scenes/DifficultySelection.tscn")

func _on_leaderboard_button_pressed() -> void:
	var panel = LeaderboardPanel.instantiate()
	get_tree().current_scene.add_child(panel)

func _on_return_button_pressed() -> void:
	GameManager.coming_from_back_button = true
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(false)
	get_tree().change_scene_to_file("res://intro/Scenes/Start.tscn")

func _on_glossary_button_pressed() -> void:
	var player = get_tree().current_scene.get_node_or_null("Intro Player")
	if player:
		await player.do_exit_sequence(true)
	get_tree().change_scene_to_file("res://intro/Scenes/Glossary.tscn")
