class_name ClawController extends Node2D


@onready var hand_sprite: Sprite2D = %HandSprite
@onready var cursor_marker: Node2D = %CursorTarget
@onready var button_grabber: RemoteTransform2D = %ButtonGrabber

func _ready() -> void:
	GlobalRefs.control_cursor = self
	await GlobalRefs.refs_ready
	button_grabber.remote_path = GlobalRefs.control_button.get_path()

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - cursor_marker.position
	if GlobalRefs.control_button.slotted:
		if Input.is_action_just_pressed("claw_grab"):
			hand_sprite.frame = 2
		if Input.is_action_just_released("claw_grab"):
			hand_sprite.frame = 1
	else:
		hand_sprite.frame = 0




func toggle_grabber(value: bool) -> void:
	button_grabber.update_position = value
	button_grabber.update_scale = value
	button_grabber.update_rotation = value
