class_name Arena
extends Node2D

const CELL_SIZE := Vector2(24, 24)
const HALF_CELL_SIZE := Vector2(12, 12)
const QUARTER_CELL_SIZE := Vector2(6, 6)

@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_spawner: UnitSpawner = $UnitSpawner


func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
