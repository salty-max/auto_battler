class_name UnitStats
extends Resource

enum RARITY {COMMON, UNCOMMON, RARE, LEGENDARY}

const RARITY_COLORS = {
	RARITY.COMMON: Color("#c2c3c7"),
	RARITY.UNCOMMON: Color("#008751"),
	RARITY.RARE: Color("#31a2f2"),
	RARITY.LEGENDARY: Color("#eb8932"),
}

@export var name: StringName

@export_category("Data")
@export var rarity: RARITY
@export var gold_cost := 1
@export_range(1, 3) var tier := 1 : set = _set_tier

@export_category("Visuals")
@export var skin: SpriteFrames


func _set_tier(value: int) -> void:
	tier = value
	emit_changed()


func get_combined_unit_count() -> int:
	return Globals.UNIT_COUNT_TO_NEXT_TIER ** (tier - 1)


func get_gold_value() -> int:
	return gold_cost * get_combined_unit_count()


func _to_string() -> String:
	return name
