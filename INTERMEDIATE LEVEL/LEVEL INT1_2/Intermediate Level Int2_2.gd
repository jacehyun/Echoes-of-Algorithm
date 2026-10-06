extends Node2D
@onready var fade_screen: ColorRect = $CanvasLayer/FadeScreen
@onready var question_panel = $"CanvasLayer/Question_Panel2-2-1"
@onready var correct_answer = $"CanvasLayer/CorrectAnswer2-2-2"
@onready var dialog_box: Panel = $Player/DialogBox
@onready var sfx_gameover: AudioStreamPlayer2D = $Sfx_gameover
@onready var sfx_bgmusic: AudioStreamPlayer2D = $Sfx_bgmusic
@onready var enemy: CharacterBody2D = $Enemy
# 1. Grab references to the Player and the Health Bar
@onready var player = $Player
@onready var health_bar = $Control/Health
# ==============================
# UPDATED: Added Label reference
# ==============================
@onready var health_label = $Control/Health/Label
# --- NEW: GAME OVER PANEL REFERENCES ---
@onready var game_over_panel = $CanvasLayer/GameOver
@onready var retry_button = $CanvasLayer/GameOver/Panel/TryAgain
@onready var exit_button = $CanvasLayer/GameOver/Panel/Exit
const LEVEL_NUMBER = "1.2"

func _ready() -> void:
	question_panel.visible = false
	fade_screen.visible = true
	fade_screen.modulate.a = 1.0
	
	sfx_bgmusic.volume_db = 0.0
	sfx_bgmusic.play()
	SaveManager.save_level(scene_file_path)
	
	if enemy:
		enemy.enemy_died.connect(_on_enemy_died)
	
	# Hide the Game Over Panel at the start just to be safe!
	if game_over_panel:
		game_over_panel.visible = false
		# Connect the buttons directly in code!
		retry_button.pressed.connect(_on_retry_pressed)
		exit_button.pressed.connect(_on_exit_pressed)
	
	var tween = create_tween()
	tween.tween_property(fade_screen, "modulate:a", 0.0, 1.5)
	tween.finished.connect(_on_fade_finished)

func _on_enemy_died() -> void:
	var tween = create_tween()
	
	tween.tween_property(sfx_bgmusic, "volume_db", -60.0, 1.5)
	tween.finished.connect(sfx_bgmusic.stop)
	
	# ==============================
	# FOR ADDING EXP
	# ==============================
	SaveManager.add_exp(100)
	
	SaveManager.submit_to_leaderboard(
		SaveManager.get_player_name(),
		LEVEL_NUMBER
	)

func _on_fade_finished() -> void:
	fade_screen.visible = false
	dialog_box.visible = true
	await get_tree().create_timer(2.5).timeout
	
	dialog_box.visible = false
	# 2. Set up the health bar's starting values
	question_panel.visible = true
	health_bar.max_value = player.max_health
	health_bar.value = player.current_health
	# ==============================
	# UPDATED: Set the label text on start
	# ==============================
	health_label.text = str(player.current_health) + "/" + str(player.max_health)
	
	# 3. Connect the player's signals to functions in this script
	player.health_changed.connect(update_health_bar)
	player.player_died.connect(trigger_game_over)
	# Your existing sequence:
	question_panel.visible = false
	correct_answer.visible = false
	await get_tree().create_timer(3.0).timeout
	question_panel.visible = true

# 4. Create the function to update the bar
func update_health_bar(new_health: int) -> void:
	health_bar.value = new_health
	# ==============================
	# UPDATED: Refresh label whenever health changes
	# ==============================
	health_label.text = str(new_health) + "/" + str(player.max_health)

# 5. Create the function for when health hits 0
func trigger_game_over() -> void:
	print("Game Over!")
	
	sfx_gameover.play()
	sfx_bgmusic.stop()
	
	SaveManager.submit_to_leaderboard(
		SaveManager.get_player_name(),
		LEVEL_NUMBER
	)
	
	# Show the Game Over panel!
	if game_over_panel:
		game_over_panel.visible = true
		
	# Optional: Lock the player so they can't move or attack while dead
	if player and player.has_method("set_can_move"):
		player.set_can_move(false)

# --- NEW: BUTTON FUNCTIONS ---
func _on_retry_pressed() -> void:
	# Instantly reload the current level to try again
	get_tree().change_scene_to_file("res://Level 1_2/Level 1_2/Scene 1_2/roaming_scene2.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://intro/Scenes/Start.tscn")
