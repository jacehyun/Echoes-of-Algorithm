extends Control

@onready var button_a = $QuestionBox/OptA
@onready var button_b = $QuestionBox/OptB
@onready var button_c = $QuestionBox/OptC
@onready var button_d = $QuestionBox/OptD
@onready var correct_popup = $"../Correct_answer2_4_1"
#@onready var hint_label = $QuestionBox/HintLabel

# --- NEW ---: Add references to your Audio nodes here
@onready var correct_sfx = $"../../Sfx_rightAnswer"
@onready var wrong_sfx = $"../../Sfx_wrongAnswer"
# -----------

var wrong_attempts := 0
var show_hint_on_reopen := false
var correct_button

func _ready() -> void:
	correct_button = button_b

	#hint_label.visible = false 
	
	button_a.pressed.connect(func(): check_answer(button_a))
	button_b.pressed.connect(func(): check_answer(button_b))
	button_c.pressed.connect(func(): check_answer(button_c))
	button_d.pressed.connect(func(): check_answer(button_d))
	
	

func check_answer(button) -> void:
	if button == correct_button:
		correct_sfx.play()
		button.modulate = Color(0, 1, 0)
		print("Correct")

		button_a.disabled = true
		button_b.disabled = true
		button_c.disabled = true
		button_d.disabled = true

		await get_tree().create_timer(1.0).timeout

		visible = false
		correct_popup.visible = true
	else:
		wrong_sfx.play()
		button.modulate = Color(1, 0, 0)
		print("Wrong")
		Input.vibrate_handheld(500)
		wrong_attempts += 1
		if wrong_attempts >= 1:
			show_hint_on_reopen = true
		
			 
		button_a.disabled = true
		button_b.disabled = true
		button_c.disabled = true
		button_d.disabled = true

		await get_tree().create_timer(1.0).timeout

		# Hide panel first
		visible = false

		# Find enemies and wait for their attack sequence
		var enemies = get_tree().get_nodes_in_group("enemy")

		for enemy in enemies:
			if enemy.has_method("start_attack_sequence"):
				await enemy.start_attack_sequence()

		# Reset buttons before showing again
		reset_question_panel()
		
		#if show_hint_on_reopen:
			#hint_label.visible = true
		# Show the question panel again
		visible = true

func reset_question_panel() -> void:
	button_a.disabled = false
	button_b.disabled = false
	button_c.disabled = false
	button_d.disabled = false

	button_a.modulate = Color(1, 1, 1, 1)
	button_b.modulate = Color(1, 1, 1, 1)
	button_c.modulate = Color(1, 1, 1, 1)
	button_d.modulate = Color(1, 1, 1, 1)
