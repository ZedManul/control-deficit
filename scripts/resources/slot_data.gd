class_name ControlSlotData extends Resource

enum Ico {
	UP,       DOWN,    RIGHT,   LEFT,
	TIMER,    PLAY,    FILE,    NOFILE,
	SETTINGS, WARNING, CONFIRM, CANCEL,
	BLANK
}

@export var icon_idx: Ico = Ico.CANCEL
@export var signal_name: String = ""
