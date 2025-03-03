extends Node

signal refs_ready



var main: Node:
	set(value):
		main = value
		inits["main"] = true
		verify_inits()

var player: CharacterBody2D:
	set(value):
		player = value
		inits["player"] = true
		verify_inits()

var control_button: ButtonController:
	set(value):
		control_button = value
		inits["control_button"] = true
		verify_inits()

var control_cursor: ClawController:
	set(value):
		control_cursor = value
		inits["control_cursor"] = true
		verify_inits()

var slot_layer: Node2D:
	set(value):
		slot_layer = value
		inits["slot_layer"] = true
		verify_inits()

var inits: Dictionary = {
	"main" : false,
	"player" : false,
	"control_button" : false,
	"control_cursor" : false,
	"slot_layer" : false,
}

var done_init: bool = false

func verify_inits() -> void:
	if done_init: return
	for i in inits.values():
		if !i: return
	refs_ready.emit()
	done_init = true
