@tool
class_name Unit
extends Area2D

@export var stats: UnitStats : set = set_stats

@onready var skin: AnimatedSprite2D = $Skin
@onready var health_bar: ProgressBar = $GUI/HealthBar
@onready var mana_bar: ProgressBar = $GUI/ManaBar


func set_stats(value: UnitStats) -> void:
	stats = value

	if not value:
		printerr("Unit -> set_stats: no value")
		return

	if not is_node_ready():
		await ready

	skin.sprite_frames = stats.skin
