extends HBoxContainer

@onready var rank_label  = $RankLabel
@onready var name_label  = $NameLabel
@onready var you_badge   = $YouBadge
@onready var level_label = $LevelLabel

func setup(rank: int, player_name: String, level: String, is_current: bool) -> void:
	rank_label.text   = str(rank) + "."
	name_label.text   = player_name
	
	var exp = SaveManager.get_exp_for(player_name)  
	
	level_label.text  = "LVL " + str(level) + " | EXP: " + str(exp)  
	you_badge.visible = is_current

	match rank:
		1: rank_label.add_theme_color_override("font_color", Color("#BA7517"))
		2: rank_label.add_theme_color_override("font_color", Color("#5F5E5A"))
		3: rank_label.add_theme_color_override("font_color", Color("#993C1D"))
		
	rank_label.custom_minimum_size  = Vector2(40, 0)
	name_label.custom_minimum_size  = Vector2(160, 0)
	you_badge.custom_minimum_size   = Vector2(50, 0)
	level_label.custom_minimum_size = Vector2(120, 0) # (optional: give more space)

	rank_label.horizontal_alignment  = HORIZONTAL_ALIGNMENT_LEFT
	name_label.horizontal_alignment  = HORIZONTAL_ALIGNMENT_LEFT
	you_badge.horizontal_alignment   = HORIZONTAL_ALIGNMENT_CENTER
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	rank_label.size_flags_horizontal  = Control.SIZE_SHRINK_BEGIN
	name_label.size_flags_horizontal  = Control.SIZE_FILL | Control.SIZE_EXPAND
	you_badge.size_flags_horizontal   = Control.SIZE_SHRINK_CENTER
	level_label.size_flags_horizontal = Control.SIZE_SHRINK_END
