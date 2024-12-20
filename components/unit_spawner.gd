class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

const UNIT := preload("res://scenes/unit/unit.tscn")

@export var bench: PlayArea
@export var game_area: PlayArea

var spawn_counter := 0


func _ready() -> void:
	var butcher := preload("res://data/units/butcher/butcher.tres")
	var dwarf := preload("res://data/units/dwarf/dwarf.tres")
	var cleric := preload("res://data/units/cleric/cleric.tres")
	var mage := preload("res://data/units/mage/mage.tres")
	var dark_elf_mage := preload("res://data/units/dark_elf_mage/dark_elf_mage.tres")
	var chtulu := preload("res://data/units/chtulu/chtulu.tres")
	var units := [butcher, dwarf, mage, cleric, dark_elf_mage, chtulu]
	var tween := create_tween()

	for i in 5:
		tween.tween_callback(spawn_unit.bind(units.pick_random()))
		tween.tween_interval(0.3)


func spawn_unit(unit: UnitStats) -> void:
	spawn_counter += 1
	var area := _get_first_available_area()
	# TODO: Alert popup if no area is available
	assert(area, "No available space to add unit to")

	var new_unit := UNIT.instantiate()
	var tile := area.unit_grid.get_first_empty_tile()

	area.unit_grid.add_child(new_unit)
	area.unit_grid.add_unit(tile, new_unit)
	new_unit.name = "%s%s" % [unit.name, spawn_counter]
	new_unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	new_unit.stats = unit.duplicate()
	unit_spawned.emit(new_unit)


func _get_first_available_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	return null
