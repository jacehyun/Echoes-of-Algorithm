extends CanvasLayer

signal name_confirmed(player_name: String)
signal cancelled

@onready var name_input:  LineEdit = $CenterContainer/PanelContainer/VBoxContainer/NameInput
@onready var error_label: Label    = $CenterContainer/PanelContainer/VBoxContainer/ErrorLabel
@onready var confirm_btn: Button   = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_btn:  Button   = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/CancelButton
@onready var panel: Panel = $Panel

func _ready() -> void:
	panel.visible    = true
	error_label.text = ""
	error_label.visible = false
	name_input.max_length = 16
	name_input.grab_focus()
	name_input.text_submitted.connect(_on_confirm_pressed)
	confirm_btn.pressed.connect(_on_confirm_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)

func _on_confirm_pressed(_text: String = "") -> void:
	var player_name = name_input.text.strip_edges().to_upper()
	if player_name.length() == 0:
		error_label.text    = "ENTER A NAME!"
		error_label.visible = true
		return
	name_confirmed.emit(player_name)  # emit BEFORE queue_free
	queue_free()

func _on_cancel_pressed() -> void:
	cancelled.emit()
	queue_free()
