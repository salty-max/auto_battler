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
@export var cost := 1

@export_category("Visuals")
@export var skin: SpriteFrames


func _to_string() -> String:
	return name
