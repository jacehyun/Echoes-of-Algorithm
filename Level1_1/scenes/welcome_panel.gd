extends Control

@onready var touch_controls: CanvasLayer = $"../../Control/TouchControls"
@onready var panel_1: Panel = $Panel1
@onready var panel_2: Panel = $Panel2
@onready var next_button: Button = $Panel1/NextButton
@onready var close_button: Button = $Panel2/CloseButton
@onready var panel_text_1: RichTextLabel = $Panel1/PanelText1
@onready var panel_text_2: RichTextLabel = $Panel2/PanelText2
@onready var interaction_manager: Node2D = $InteractionManager
@onready var sfx_dialogtyping: AudioStreamPlayer2D = $"../sfx_dialogtyping"

var typing_speed: float = 0.05
var start_delay: float = 1.8

func _ready() -> void:
	self.visible = false
	panel_1.visible = false
	panel_2.visible = false
	
	
	if interaction_manager:
		interaction_manager.open_ui()
		
	next_button.pressed.connect(_on_next_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
	await get_tree().create_timer(start_delay).timeout
	
	self.visible = true
	panel_1.visible = true
	type_text(panel_text_1)
	

func _on_next_button_pressed() -> void:
	panel_1.visible = false
	panel_2.visible = true
	
	type_text(panel_text_2)

func _on_close_button_pressed() -> void:
	self.visible = false 
	
	if interaction_manager:
		interaction_manager.close_ui()
	
	
	touch_controls.visible = true
		
func type_text(label : RichTextLabel) -> void:
	label.visible_characters = 0
	
	var total_chars = label.get_total_character_count()
	var duration = total_chars * typing_speed
	
	sfx_dialogtyping.stop()
	sfx_dialogtyping.play()
	
	var tween = create_tween()
	tween.tween_property(label, "visible_characters", total_chars, duration)
	
	tween.tween_callback(sfx_dialogtyping.stop)
