class_name ButtonController extends Node2D

signal slot_changed(slot: Node2D)

@export var grab_radius: float = 16.0
@export var snap_radius: float = 16.0

var slotted: bool = true
var current_slot: Node2D: 
	set(value):
		current_slot = value
		slot_changed.emit(current_slot)


@onready var low_sprite: Sprite2D = %LowSprite
@onready var base_sprite: Sprite2D = %BaseSprite
@onready var icon_sprite: Sprite2D = %IconSprite
@onready var ico_pos_up: Node2D = %IcoPosUp
@onready var ico_pos_down: Node2D = %IcoPosDown


func _ready() -> void:
	GlobalRefs.control_button = self
	await GlobalRefs.refs_ready
	find_priority_slot()


func _physics_process(delta: float) -> void:
	if !current_slot:
		find_priority_slot()
	if slotted and current_slot:
		global_position = lerp(global_position, current_slot.global_position, 0.5)
		global_rotation = lerp_angle(global_rotation, 0, 0.5)
		low_sprite.hide()
		if Input.is_action_just_pressed("claw_grab"):
			GlobalRefs.control_cursor.toggle_grabber(true)
			slotted = false
	else:
		low_sprite.show()
		if Input.is_action_just_released("claw_grab"):
			var new_slot = find_slot(snap_radius)
			if new_slot: current_slot = new_slot
			GlobalRefs.control_cursor.toggle_grabber(false)
			slotted = true

func find_slot(max_dist: float = INF) -> Node2D:
	var closest_dist = max_dist*max_dist
	var picked_slot = null
	for i in GlobalRefs.slot_layer.get_children():
		if Vector2(i.global_position - global_position).length_squared() < closest_dist:
			picked_slot = i
	return picked_slot

func find_priority_slot() -> void:
	var closest_dist := INF
	var p := false
	for i in GlobalRefs.slot_layer.get_children():
		var ip = i.priority
		p = ip or p
		if p and not ip:
			continue
		if Vector2(i.global_position - global_position).length_squared() < closest_dist:
			current_slot = i
