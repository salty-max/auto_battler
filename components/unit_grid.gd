class_name UnitGrid
extends Node2D

signal unit_grid_changed

@export var size: Vector2i

var units: Dictionary


func _ready() -> void:
	for col in size.x:
		for row in size.y:
			units[Vector2i(col, row)] = null
	#_debug()


func get_all_units() -> Array[Unit]:
	var result: Array[Unit] = []
	for unit: Unit in units.values():
		if unit:
			result.append(unit)
	return result


func get_unit(tile: Vector2i) -> Unit:
	return units[tile]


func add_unit(tile: Vector2i, unit: Unit) -> void:
	units[tile] = unit
	unit_grid_changed.emit()


func remove_unit(tile: Vector2i) -> void:
	var unit := units[tile] as Unit
	if not unit:
		return
	units[tile] = null
	unit_grid_changed.emit()


func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null


func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)


func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile
	# no empty tile
	return Vector2i(-1, -1)


func _debug() -> void:
	var u = get_all_units()
	print(name)
	print("\noccupancy: %s/%s" % [u.size(), units.size()])
	for tile: Vector2i in units:
		print("\t%s: %s" % [tile, units[tile]])
	print("\nis_grid_full: ", is_grid_full())
	print("\nfirst_empty_tile: %s\n" % get_first_empty_tile())
