extends Node2D


@export var cursor_marker: Node2D
@export var hand_sprite_rdy: Sprite2D
@export var hand_sprite_grab: Sprite2D
@export var hand_sprite_misgrab: Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position() - cursor_marker.position
