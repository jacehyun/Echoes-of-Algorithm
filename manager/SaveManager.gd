#extends Node
#
#const SAVE_PATH = "user://savegame.save"zz
#
## This function takes the path of whatever level calls it and saves it
#func save_level(level_path: String) -> void:
	#var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#if file:
		#file.store_string(level_path)
		#print("Game saved globally at: ", level_path)
#
#func get_saved_level() -> String:
	#if FileAccess.file_exists(SAVE_PATH):
		#var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		#return file.get_as_text()
	#return ""

extends Node

const SAVE_PATH        = "user://savegame.save"
const LEADERBOARD_PATH = "user://leaderboard.save"
const MAX_ENTRIES      = 10

# Saves a level for a specific player
func save_level(level_path: String) -> void:
	var data = _load_raw()
	var current = data.get("current_player", "")
	if current == "":
		return
	var players = data.get("players", {})
	if not players.has(current):
		players[current] = {}
	players[current]["level_path"] = level_path
	data["players"] = players
	_write(data)
	print("Saved level for: ", current, " → ", level_path)

func save_player_name(player_name: String) -> void:
	var data = _load_raw()
	var players = data.get("players", {})
	if not players.has(player_name):
		players[player_name] = { "level_path": "" }
	data["players"]        = players
	data["current_player"] = player_name
	_write(data)
	print("Active player set to: ", player_name)

func set_current_player(player_name: String) -> void:
	var data = _load_raw()
	data["current_player"] = player_name
	_write(data)

func get_player_name() -> String:
	return _load_raw().get("current_player", "")

func get_all_players() -> Array:
	var players = _load_raw().get("players", {})
	return players.keys()

func get_saved_level() -> String:
	var data    = _load_raw()
	var current = data.get("current_player", "")
	var players = data.get("players", {})
	if players.has(current):
		return players[current].get("level_path", "")
	return ""

func get_saved_level_for(player_name: String) -> String:
	var players = _load_raw().get("players", {})
	if players.has(player_name):
		return players[player_name].get("level_path", "")
	return ""

func has_save() -> bool:
	var data    = _load_raw()
	var players = data.get("players", {})
	return not players.is_empty()

func has_player(player_name: String) -> bool:
	return _load_raw().get("players", {}).has(player_name)

func delete_player(player_name: String) -> void:
	var data    = _load_raw()
	var players = data.get("players", {})
	players.erase(player_name)
	data["players"] = players
	if data.get("current_player", "") == player_name:
		data["current_player"] = ""
	_write(data)

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

# --- Leaderboard (unchanged) ---
func submit_to_leaderboard(player_name: String, level_reached: String) -> void:
	var entries = get_leaderboard()
	var found = false
	for entry in entries:
		if entry["name"] == player_name:
			if float(level_reached) > float(str(entry["level"])):  # ← str() before float()
				entry["level"] = level_reached
			found = true
			break
	if not found:
		entries.append({ "name": player_name, "level": level_reached })
	entries.sort_custom(func(a, b): return float(str(a["level"])) > float(str(b["level"])))
	if entries.size() > MAX_ENTRIES:
		entries = entries.slice(0, MAX_ENTRIES)
	var file = FileAccess.open(LEADERBOARD_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(entries))

func get_leaderboard() -> Array:
	if not FileAccess.file_exists(LEADERBOARD_PATH):
		return []
	var file = FileAccess.open(LEADERBOARD_PATH, FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			return parsed
	return []

func clear_leaderboard() -> void:
	if FileAccess.file_exists(LEADERBOARD_PATH):
		DirAccess.remove_absolute(LEADERBOARD_PATH)
		
		
# ==============================
# GAME FLAGS (difficulty unlocks)
# ==============================

func save_flags(finished_beginner: bool, finished_intermediate: bool, finished_advanced: bool) -> void:
	var data    = _load_raw()
	var current = data.get("current_player", "")
	if current == "":
		return
	var players = data.get("players", {})
	if not players.has(current):
		players[current] = {}
	# Store flags INSIDE the player's own data
	players[current]["finished_beginner_game"]     = finished_beginner
	players[current]["finished_intermediate_game"] = finished_intermediate
	players[current]["finished_advanced_game"] = finished_advanced
	data["players"] = players
	_write(data)
	print("Flags saved for: ", current)

func is_beginner_done() -> bool:
	var data    = _load_raw()
	var current = data.get("current_player", "")
	var players = data.get("players", {})
	if players.has(current):
		return players[current].get("finished_beginner_game", false)
	return false

func is_intermediate_done() -> bool:
	var data    = _load_raw()
	var current = data.get("current_player", "")
	var players = data.get("players", {})
	if players.has(current):
		return players[current].get("finished_intermediate_game", false)
	return false

func is_advanced_done() -> bool:
	var data    = _load_raw()
	var current = data.get("current_player", "")
	var players = data.get("players", {})
	if players.has(current):
		return players[current].get("finished_advanced_game", false)
	return false
# ===============================================
# GAME FLAGS (difficulty unlocks) - end of line
# ===============================================

func _write(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func _load_raw() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Dictionary:
			return parsed
	return {}
	
	
	#==============================================
	# ==============================
# EXP SYSTEM
# ==============================

func add_exp(amount: int) -> void:
	var data = _load_raw()
	var current = data.get("current_player", "")
	if current == "":
		return
	var players = data.get("players", {})
	if not players.has(current):
		players[current] = {}
	# Get existing EXP or start at 0
	var current_exp = players[current].get("exp", 0)
	players[current]["exp"] = current_exp + amount
	data["players"] = players
	_write(data)
	print("EXP added: +", amount, " | Total: ", players[current]["exp"])

func get_exp() -> int:
	var data = _load_raw()
	var current = data.get("current_player", "")
	var players = data.get("players", {})
	if players.has(current):
		return players[current].get("exp", 0)
	return 0

func get_exp_for(player_name: String) -> int:
	var players = _load_raw().get("players", {})
	if players.has(player_name):
		return players[player_name].get("exp", 0)
	return 0
