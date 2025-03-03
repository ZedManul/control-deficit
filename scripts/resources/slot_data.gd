@tool
class_name ControlSlotData extends Resource

signal icon_idx_changed

enum Ico {
	UP,       DOWN,    RIGHT,   LEFT,
	TIMER,    PLAY,    FILE,    NOFILE,
	SETTINGS, WARNING, CONFIRM, CANCEL,
	OFF, BLANK,
}

@export var icon_idx: Ico = Ico.CANCEL:
	set(value):
		icon_idx = value
		icon_idx_changed.emit()
@export var signal_name: String = ""
