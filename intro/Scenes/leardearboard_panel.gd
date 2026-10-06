extends CanvasLayer

const EntryRow = preload("res://intro/Scenes/LeaderboardEntryRow.tscn")

@onready var entries_list = $CenterContainer/PanelContainer/VBoxContainer/EntriesList
@onready var close_btn    = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/CloseButton

func _ready() -> void:
	close_btn.pressed.connect(func(): queue_free())
	_populate()

func _populate() -> void:
	# Clear old rows
	for child in entries_list.get_children():
		child.queue_free()

	var leaderboard = SaveManager.get_leaderboard()
	var current_player = SaveManager.get_player_name()

	if leaderboard.is_empty():
		var empty_label = Label.new()
		empty_label.text = "NO RECORDS YET!"
		entries_list.add_child(empty_label)
		return

	for i in leaderboard.size():
		var entry = leaderboard[i]
		var row = EntryRow.instantiate()
		entries_list.add_child(row)
		row.setup(i + 1, entry["name"], str(entry["level"]), entry["name"] == current_player)
