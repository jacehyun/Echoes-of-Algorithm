extends Control

@onready var start_panel = get_node_or_null("../StartPanel")
@onready var menu_panel = get_node_or_null("../MainMenu")
@onready var difficulty_panel = get_node_or_null("../DifficultySelectPanel")
@onready var glossary_panel = get_node_or_null("../Glossary")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 1. Find the current volume of the Master bus
	var bus_index = AudioServer.get_bus_index("Master")
	var current_db = AudioServer.get_bus_volume_db(bus_index)
	
	# 2. Set the slider handle to match that volume
	# (Matches the slider position to the actual game volume)
	$SettingsMenu_Panel/MarginContainer/VBoxContainer/HBoxContainer/HSlider.value = db_to_linear(current_db)

func _on_settings_menu_button_pressed():
	# Check for StartPanel (used in Start scene)
	if start_panel:
		start_panel.visible = false
	
	# Check for MenuPanel (or whatever your Main Menu buttons are called)
	if menu_panel:
		menu_panel.visible = false
	
	if difficulty_panel:
		difficulty_panel.visible = false
	
	if glossary_panel:
		glossary_panel.visible = false

	# Show the Settings
	$SettingsMenu_Button.visible = false
	$SettingsMenu_Panel.visible = true


# This runs when the slider is moved
func _on_h_slider_value_changed(value: float) -> void:
	# This line controls the volume of the entire game engine
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_resume_button_pressed() -> void:
	$SettingsMenu_Panel.visible = false
	$SettingsMenu_Button.visible = true
	
	# Bring back whichever panel was hidden
	if start_panel:
		start_panel.visible = true
		
	if menu_panel:
		menu_panel.visible = true
	
	if difficulty_panel:
		difficulty_panel.visible = true
	
	if glossary_panel:
		glossary_panel.visible = true

func _on_restart_button_pressed() -> void:
	# 1. Unpause the game (important if your settings menu pauses the game)
	get_tree().paused = false
	
	# 2. Reload the scene that is currently open
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	$SettingsMenu_Panel.visible = false
	$ExitConfirmation_Panel.visible = true


func _on_confirm_exit_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_exit_button_pressed() -> void:
	$ExitConfirmation_Panel.visible = false
	$SettingsMenu_Panel.visible = true
