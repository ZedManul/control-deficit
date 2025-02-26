extends Node2D


@export var grab_radius: float = 16.0
@export var snap_radius: float = 16.0

var slotted: bool = false

@onready var light_sprites: Array[Sprite2D] = [%LightSprites1, %LightSprites2]
