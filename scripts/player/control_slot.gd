@tool
class_name SlotController extends Node2D


@export var slot_data: ControlSlotData:
	set(value):
		slot_data = value
		if !slot_data: return
		if !slot_data.icon_idx_changed.is_connected(change_icon):
			slot_data.icon_idx_changed.connect(change_icon)

@export var priority = false

@onready var icon_sprite: Sprite2D = %IconSprite

func _ready() -> void:
	change_icon()
	if Engine.is_editor_hint():
		return
	await GlobalRefs.refs_ready
	GlobalRefs.control_button.slot_changed.connect(on_button_slot_changed)

func change_icon() -> void:
	if !slot_data: return
	icon_sprite.frame = slot_data.icon_idx

func on_button_slot_changed(slot: Node2D) -> void:
	icon_sprite.visible = slot != self
