extends Node2D

var swoosh_scene = preload("res://scenes/Swoosh.tscn")

func _ready() -> void:
	var s = swoosh_scene.instantiate()
	add_child(s)
	s.global_position = Vector2(200, 200)
	s.set_direction(1)
