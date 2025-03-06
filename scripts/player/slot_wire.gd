@tool
extends Rope

func _ready() -> void:
	if Engine.is_editor_hint(): return
	await GlobalRefs.refs_ready
	GlobalRefs.control_button.slot_changed.connect(_on_slot_change)

func _on_slot_change(new_slot: SlotController) -> void:
	if !new_slot: return
	global_position = new_slot.global_position
