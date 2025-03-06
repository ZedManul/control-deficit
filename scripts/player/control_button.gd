class_name ButtonController extends Node2D

signal slot_changed(slot: Node2D)
signal main_button_pressed
signal main_button_released

@export var grab_radius: float = 16.0
@export var snap_radius: float = 16.0
@export var button_shift: Vector2 = Vector2.ZERO
@export_group("glow tween")
@export var off_modulate: Color = Color.DARK_MAGENTA
@export var on_modulate: Color = Color.WHITE
@export var tween_length: float = 0.8

var slotted: bool = true
var current_slot: Node2D: 
	set(value):
		current_slot = value
		slot_changed.emit(current_slot)
var button_press_tween: Tween

@onready var low_sprite: Sprite2D = %Low
@onready var icon_sprite: Sprite2D = %Icon
@onready var ico_pos_up: Node2D = %IcoPosUp
@onready var ico_pos_down: Node2D = %IcoPosDown
@onready var moving_sprites: Node2D = %MovingSprites


func _ready() -> void:
	for i in get_tree().get_nodes_in_group("glow"):
		i.modulate = off_modulate
	slot_changed.connect(on_slot_change)
	GlobalRefs.control_button = self
	await GlobalRefs.refs_ready
	find_priority_slot()



func _physics_process(delta: float) -> void:
	if !current_slot:
		find_priority_slot()
		return
	if Input.is_action_just_pressed("btn_press"):
		main_button_pressed.emit()
		tween_button_press(true)
	
	if Input.is_action_just_released("btn_press"):
		main_button_released.emit()
		tween_button_press(false)
	
	if Input.is_action_pressed("btn_press"):
		if ControlSignalBus.has_signal(current_slot.signal_name):
			ControlSignalBus.emit_signal(current_slot.signal_name, delta)
	
	if slotted and current_slot:
		global_position = lerp(global_position, current_slot.global_position, 0.5)
		global_rotation = lerp_angle(global_rotation, 0, 0.5)
		var claw_dist = Vector2(global_position - GlobalRefs.control_cursor.cursor_marker.global_position).length_squared()
		low_sprite.hide()
		if Input.is_action_just_pressed("claw_grab") and claw_dist < grab_radius * grab_radius:
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
	for i in get_tree().get_nodes_in_group("button_slots"):
		var dist = Vector2(i.global_position - global_position).length_squared()
		if dist < closest_dist:
			closest_dist = dist
			picked_slot = i
	return picked_slot

func find_priority_slot() -> void:
	var closest_dist := INF
	var p := false
	for i in get_tree().get_nodes_in_group("button_slots"):
		var dist = Vector2(i.global_position - global_position).length_squared()
		var ip = i.priority
		if not p and ip:
			closest_dist = dist
			current_slot = i
			p = ip
		if p and not ip:
			continue
		if dist < closest_dist:
			closest_dist = dist
			current_slot = i


func tween_button_press(pressed: bool) -> void:
	var clr_val = off_modulate
	var pos_val = Vector2.ZERO
	if pressed:
		clr_val = on_modulate
		pos_val = button_shift
	if button_press_tween:
		button_press_tween.kill()
	button_press_tween = create_tween()
	button_press_tween.set_parallel(true)
	button_press_tween.set_trans(Tween.TRANS_ELASTIC)
	button_press_tween.set_ease(Tween.EASE_OUT)
	button_press_tween.tween_property(moving_sprites,"position",pos_val,tween_length)
	button_press_tween.set_trans(Tween.TRANS_QUINT)
	button_press_tween.set_ease(Tween.EASE_OUT)
	for i in get_tree().get_nodes_in_group("glow"):
		button_press_tween.tween_property(i,"modulate", clr_val, tween_length)

func on_slot_change(slot: SlotController) -> void:
	if !slot:
		icon_sprite.frame = SlotController.Ico.BLANK
		return
	
	icon_sprite.frame = slot.icon_idx
