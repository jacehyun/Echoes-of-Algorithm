extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

const lines: Array[String] = [
	"Tap to interact "
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	DialogManager.start_dialog(global_position, lines)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x <global_positionn.x 
	elif 
	await DialogManager.dialog_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
