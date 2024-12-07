@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

@export var stats: UnitStats : set = set_stats

@onready var skin: AnimatedSprite2D = %Skin
@onready var shadow: Sprite2D = $Visuals/Shadow
@onready var health_bar: ProgressBar = %HealthBar
@onready var mana_bar: ProgressBar = %ManaBar
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation

var is_hovered := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.dropped.connect(_on_dropped)
		quick_sell_pressed.connect(func(): print("sell"))

	skin.play("active")


func _input(event: InputEvent) -> void:
	if not is_hovered:
		return
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()


func set_stats(value: UnitStats) -> void:
	stats = value

	if not value:
		printerr("Unit -> set_stats: no value")
		return

	if not is_node_ready():
		await ready

	skin.sprite_frames = stats.skin
	skin.play("active")


func reset_after_dragging(starting_pos: Vector2) -> void:
	skin.play("active")
	velocity_based_rotation.enabled = false
	global_position = starting_pos


func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	is_hovered = true
	outline_highlighter.highlight()
	z_index = 1


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	is_hovered = false
	outline_highlighter.clear_highlight()
	z_index = 0


func _on_drag_started() -> void:
	skin.play("idle")
	shadow.visible = false
	velocity_based_rotation.enabled = true


func _on_drag_canceled(starting_pos: Vector2) -> void:
	shadow.visible = true
	reset_after_dragging(starting_pos)


func _on_dropped(_starting_pos: Vector2) -> void:
	skin.play("active")
	shadow.visible = true
	velocity_based_rotation.enabled = false
