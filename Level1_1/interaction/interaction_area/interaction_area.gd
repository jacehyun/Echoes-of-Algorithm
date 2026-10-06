extends Area2D

@export var info_panel: Control
@export_multiline var scroll_text: String = "Write your lore here..."

@onready var label = info_panel.find_child("Label") # Finds the label in your ScrollContainer

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# This is the function the InteractionManager calls
func interact():
	label.text = scroll_text
	info_panel.visible = !info_panel.visible # Toggle the panel
	
	# Optional: Pause the game or lock player movement while reading
	# InteractionManager.can_interact = !info_panel.visible

func _on_body_entered(body):
	if body.is_in_group("player"):
		InteractionManager.register_area(self)
		# Optional: Show a "Press E to Read" floating prompt here

func _on_body_exited(body):
	if body.is_in_group("player"):
		InteractionManager.unregister_area(self)
		info_panel.hide()
