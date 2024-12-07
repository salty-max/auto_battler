class_name UnitMover
extends Node

@export var play_areas: Array[PlayArea]


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))


func _set_highlighters(enabled: bool) -> void:
	for play_area: PlayArea in play_areas:
		play_area.tile_highlighter.enabled = enabled


func _get_play_area_for_position(global: Vector2) -> int:
	var dropped_area_index := -1
	for i: int in play_areas.size():
		var tile := play_areas[i].get_tile_from_global(global)
		if play_areas[i].is_tile_in_bounds(tile):
			dropped_area_index = i

	return dropped_area_index


func _reset_unit_to_starting_position(starting_pos: Vector2, unit: Unit) -> void:
	var index := _get_play_area_for_position(starting_pos)
	var tile := play_areas[index].get_tile_from_global(starting_pos)

	unit.reset_after_dragging(starting_pos)
	play_areas[index].unit_grid.add_unit(tile, unit)


func _move_unit(unit: Unit, play_area: PlayArea, tile: Vector2i) -> void:
	play_area.unit_grid.add_unit(tile, unit)
	unit.global_position = play_area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	unit.reparent(play_area.unit_grid)


func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)

	var index := _get_play_area_for_position(unit.global_position)
	if index > -1:
		var tile := play_areas[index].get_tile_from_global(unit.global_position)
		play_areas[index].unit_grid.remove_unit(tile)


func _on_unit_drag_canceled(starting_pos: Vector2, unit: Unit) -> void:
	_set_highlighters(false)
	_reset_unit_to_starting_position(starting_pos, unit)


func _on_unit_dropped(starting_pos: Vector2, unit: Unit) -> void:
	_set_highlighters(false)

	var start_area_index := _get_play_area_for_position(starting_pos)
	var drop_area_index := _get_play_area_for_position(unit.get_global_mouse_position())

	if drop_area_index == -1:
		_reset_unit_to_starting_position(starting_pos, unit)
		return

	var start_area := play_areas[start_area_index]
	var start_tile := start_area.get_tile_from_global(starting_pos)
	var drop_area := play_areas[drop_area_index]
	var drop_tile := drop_area.get_hovered_tile()

	# Swap units if drop tile is occupied
	if drop_area.unit_grid.is_tile_occupied(drop_tile):
		# Move old unit to starting tile
		var old_unit: Unit = drop_area.unit_grid.get_unit(drop_tile)
		drop_area.unit_grid.remove_unit(drop_tile)
		_move_unit(old_unit, start_area, start_tile)

	# Move dropped unit to drop tile
	_move_unit(unit, drop_area, drop_tile)
