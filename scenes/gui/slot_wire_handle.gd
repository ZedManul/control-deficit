@tool
extends RopeHandle

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	if GlobalRefs.control_button.current_slot:
		global_position = GlobalRefs.control_button.current_slot.global_position
	
