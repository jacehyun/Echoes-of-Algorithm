extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://intro/Scenes/MainMenu_Page.tscn")


func _on_settings_menu_button_pressed():
	$StartPage_BG/Start_Panel.visible = false
	$StartPage_BG/SettingsMenu_Button.visible = false
	$StartPage_BG/SettingsMenu_Panel.visible = true


func _on_resume_button_pressed():
	$StartPage_BG/SettingsMenu_Panel.visible = false
	$StartPage_BG/SettingsMenu_Button.visible = true
	$StartPage_BG/Start_Panel.visible = true


func _on_settings_button_pressed():
	$StartPage_BG/SettingsMenu_Panel.visible = false
	$StartPage_BG/Settings_Panel.visible = true


func _on_exit_button_pressed():
	$StartPage_BG/SettingsMenu_Panel.visible = false
	$StartPage_BG/ExitConfirmation_Panel.visible = true


func _on_confirm_exit_button_pressed():
	get_tree().quit()


func _on_cancel_exit_button_pressed():
	$StartPage_BG/ExitConfirmation_Panel.visible = false
	$StartPage_BG/SettingsMenu_Panel.visible = true
