extends CharacterBody2D

var grav = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var acceleration: float = 10.0
@export var max_speed: float = 300.0
@export var jump_vel: float = 350.0
@export var friction: float = 0.1
@export var input_buffer: float = 0.2
@export var coyote_timer: Timer: 
	set(value):
		coyote_timer = value
		if !coyote_timer.timeout.is_connected(coyote_timeout):
			coyote_timer.timeout.connect(coyote_timeout)
@export var buffer_timer: Timer: 
	set(value):
		buffer_timer = value
		if !buffer_timer.timeout.is_connected(buffer_timeout):
			buffer_timer.timeout.connect(buffer_timeout)


var can_jump: bool = true
var want_jump: bool = false


func _ready() -> void:
	ControlSignalBus.inp_jump.connect(handle_jump_input)
	ControlSignalBus.inp_left.connect(handle_move_left)
	ControlSignalBus.inp_right.connect(handle_move_right)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer.start()
		can_jump = true
	
	if !is_on_floor():
		velocity.y += grav * delta
	velocity = velocity * (1.0 - friction)
	
	handle_jump()
	move_and_slide()

func handle_jump() -> void:
	if !want_jump or !can_jump:
		return
	velocity.y = -jump_vel
	coyote_timer.stop()
	can_jump = false

func handle_jump_input() -> void:
	want_jump = true
	buffer_timer.start()

func handle_move_left() -> void:
	if velocity.x > -max_speed:
		velocity.x -= acceleration


func handle_move_right() -> void:
	if velocity.x < max_speed:
		velocity.x += acceleration


func coyote_timeout() -> void:
	can_jump = false


func buffer_timeout() -> void:
	want_jump = false
