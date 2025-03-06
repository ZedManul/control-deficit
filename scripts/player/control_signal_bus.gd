extends Node

signal inp_left
signal inp_right
signal inp_jump

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		inp_left.emit(delta)
	if Input.is_action_pressed("ui_right"):
		inp_right.emit(delta)
	if Input.is_action_pressed("ui_up"):
		inp_jump.emit(delta)
