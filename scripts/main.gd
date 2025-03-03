extends Node

func _ready() -> void:
	GlobalRefs.main = self
	GlobalRefs.slot_layer = %SlotLayer
