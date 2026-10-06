extends CanvasLayer

signal player_selected(player_name: String)
signal new_player_requested
signal cancelled

@onready var player_list     = $CenterContainer/PanelContainer/VBoxContainer/PlayerList
@onready var new_player_btn  = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/NewPlayerButton
@onready var cancel_btn      = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/CancelButton
@onready var panel1: Panel = $Panel

func _ready() -> void:
	panel1.visible = true
	new_player_btn.pressed.connect(func():
		new_player_requested.emit()
		queue_free()
	)
	cancel_btn.pressed.connect(func():
		cancelled.emit()
		queue_free()
	)
	_populate()

func _populate() -> void:
	for child in player_list.get_children():
		child.queue_free()

	var players = SaveManager.get_all_players()
	for p in players:
		var raw_level = SaveManager.get_saved_level_for(p)

		# Fix 1 — clean level display text
		var level_text = "NEW"
		if raw_level != "":
			var filename = raw_level.get_file().get_basename()
			var clean = filename.replace("level_","Level ").replace("_", ".")
			level_text = " " + clean

		# Fix 2 — styled row
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 0)

		var name_lbl = Label.new()
		name_lbl.text = p
		name_lbl.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		name_lbl.add_theme_color_override("font_color", Color("000000ff"))

		var level_lbl = Label.new()
		level_lbl.text = level_text
		level_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		level_lbl.add_theme_color_override("font_color", Color("#EF9F27"))

		var panel = PanelContainer.new()
		panel.add_child(row)
		row.add_child(name_lbl)
		row.add_child(level_lbl)

		var style = StyleBoxFlat.new()
		style.bg_color = Color("ffffffff")
		style.border_width_bottom = 2
		style.border_color = Color("#EF9F27")
		style.set_corner_radius_all(6)
		style.content_margin_left   = 20
		style.content_margin_right  = 20
		style.content_margin_top    = 20
		style.content_margin_bottom = 20
		panel.add_theme_stylebox_override("panel", style)

		panel.mouse_filter = Control.MOUSE_FILTER_STOP
		panel.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				SaveManager.set_current_player(p)
				player_selected.emit(p)
				queue_free()
		)

		player_list.add_child(panel)
#func _populate() -> void:
	#for child in player_list.get_children():
		#child.queue_free()
#
	#var players = SaveManager.get_all_players()
	#for p in players:
		#var btn = Button.new()
		#var level = SaveManager.get_saved_level_for(p)
		#btn.text = p + ("  [" + level.get_file().get_basename().to_upper() + "]" if level != "" else "  [NEW]")
		#btn.pressed.connect(func():
			#SaveManager.set_current_player(p)
			#player_selected.emit(p)
			#queue_free()
		#)
		#player_list.add_child(btn)
