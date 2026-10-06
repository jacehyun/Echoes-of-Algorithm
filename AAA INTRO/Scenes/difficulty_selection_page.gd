extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu_Page.tscn")


func _on_settings_menu_button_pressed():
	$DifficultySelection_BG/DifficultySelectButton_Container.visible = false
	$DifficultySelection_BG/Return_Button.visible = false
	$DifficultySelection_BG/SettingsMenu_Button.visible = false
	$DifficultySelection_BG/SettingsMenu_Panel.visible = true


func _on_resume_button_pressed():
	$DifficultySelection_BG/SettingsMenu_Panel.visible = false
	$DifficultySelection_BG/Return_Button.visible = true
	$DifficultySelection_BG/SettingsMenu_Button.visible = true
	$DifficultySelection_BG/DifficultySelectButton_Container.visible = true


func _on_settings_button_pressed():
	$DifficultySelection_BG/SettingsMenu_Panel.visible = false
	$DifficultySelection_BG/Settings_Panel.visible = true


func _on_exit_button_pressed():
	$DifficultySelection_BG/SettingsMenu_Panel.visible = false
	$DifficultySelection_BG/ExitConfirmation_Panel.visible = true


func _on_confirm_exit_button_pressed():
	get_tree().quit()


func _on_cancel_exit_button_pressed():
	$DifficultySelection_BG/ExitConfirmation_Panel.visible = false
	$DifficultySelection_BG/SettingsMenu_Panel.visible = true


func _on_intermediate_button_pressed():
	$DifficultySelection_BG/DifficultySelectButton_Container.visible = false
	$DifficultySelection_BG/Return_Button.visible = false
	$DifficultySelection_BG/SettingsMenu_Button.visible = false
	$DifficultySelection_BG/LevelLockWarning_Panel.visible = true


func _on_advanced_button_pressed():
	$DifficultySelection_BG/DifficultySelectButton_Container.visible = false
	$DifficultySelection_BG/Return_Button.visible = false
	$DifficultySelection_BG/SettingsMenu_Button.visible = false
	$DifficultySelection_BG/LevelLockWarning_Panel.visible = true


func _on_okay_button_pressed():
	$DifficultySelection_BG/LevelLockWarning_Panel.visible = false
	$DifficultySelection_BG/Return_Button.visible = true
	$DifficultySelection_BG/SettingsMenu_Button.visible = true
	$DifficultySelection_BG/DifficultySelectButton_Container.visible = true
