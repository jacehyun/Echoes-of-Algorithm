extends Control

@onready var introbg: AudioStreamPlayer2D = $introbg

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	introbg.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://intro/Scenes/Start_Page.tscn")

func _on_settings_menu_button_pressed():
	$MainMenu_BG/MainMenuButtons_Container.visible = false
	$MainMenu_BG/Return_Button.visible = false
	$MainMenu_BG/SettingsMenu_Button.visible = false
	$MainMenu_BG/SettingsMenu_Panel.visible = true


func _on_resume_button_pressed():
	$MainMenu_BG/SettingsMenu_Panel.visible = false
	$MainMenu_BG/Return_Button.visible = true
	$MainMenu_BG/SettingsMenu_Button.visible = true
	$MainMenu_BG/MainMenuButtons_Container.visible = true


func _on_settings_button_pressed():
	$MainMenu_BG/SettingsMenu_Panel.visible = false
	$MainMenu_BG/Settings_Panel.visible = true


func _on_exit_button_pressed():
	$MainMenu_BG/SettingsMenu_Panel.visible = false
	$MainMenu_BG/ExitConfirmation_Panel.visible = true


func _on_confirm_exit_button_pressed():
	get_tree().quit()


func _on_cancel_exit_button_pressed():
	$MainMenu_BG/ExitConfirmation_Panel.visible = false
	$MainMenu_BG/SettingsMenu_Panel.visible = true


func _on_new_game_button_pressed():
	pass # Replace with function body.


func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://intro/Scenes/DifficultySelection_Page.tscn")


func _on_glossary_button_pressed():
	get_tree().change_scene_to_file("res://intro/Scenes/Glossary_Page.tscn")
