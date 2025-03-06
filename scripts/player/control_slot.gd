@tool
class_name SlotController extends Node2D

enum Ico {
	UP,       DOWN,    RIGHT,   LEFT,
	TIMER,    PLAY,    FILE,    NOFILE,
	SETTINGS, WARNING, CONFIRM, CANCEL,
	OFF, BLANK,
}

@export var icon_idx: Ico:
	set(value):
		icon_idx = value
		change_icon()

@export var signal_name: String

@export var priority = false

@onready var icon_sprite: Sprite2D = %IconSprite

func _init() -> void:
	add_to_group("button_slots", true)

func _ready() -> void:
	change_icon()
	if Engine.is_editor_hint():
		return
	await GlobalRefs.refs_ready
	GlobalRefs.control_button.slot_changed.connect(on_button_slot_changed)

func change_icon() -> void:
	if !icon_sprite: return
	icon_sprite.frame = icon_idx

func on_button_slot_changed(slot: Node2D) -> void:
	icon_sprite.visible = slot != self
