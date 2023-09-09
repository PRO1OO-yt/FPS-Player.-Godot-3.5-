extends KinematicBody

export(String) var forward_action = "w"
export(String) var back_run_action = "s"
export(String) var right_action = "a"
export(String) var left_action = "d"
export(String) var jump_action = "sp"
export(float, 0, 1, 0.01) var sensitive = 0.3
export(int, 1, 50, 1) var speed = 20
export(int, 1, 50, 1) var jump = 20
export(int, -100, 30, 1) var gravity = -30
export(float, 10, 120, 0.5) var fov = 70

const FRICTION = 500

var can_rotation_camera : bool = true
var motion = Vector2.ZERO
var vel = Vector3()

onready var cam = $head

func _ready():
	$head/Camera.fov = fov
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if can_rotation_camera:
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * sensitive))
			cam.rotate_x(deg2rad(event.relative.y * sensitive))
			cam.rotation.x = clamp(cam.rotation.x, deg2rad(-90), deg2rad(90))
	
	if Input.is_action_just_pressed("ui_cancel"):
		if can_rotation_camera:
			can_rotation_camera = false
		else:
			can_rotation_camera = true

func _physics_process(delta):
	$head/Camera.current = true
	_control_player(delta)
	
func _control_player(delta):
	var input_dir = Vector2.ZERO
	input_dir.x = int(Input.is_action_pressed(right_action)) - int(Input.is_action_pressed(left_action))
	input_dir.y = int(Input.is_action_pressed(forward_action)) - int(Input.is_action_pressed(back_run_action))
	input_dir = input_dir.normalized().rotated(-rotation.y)
	
	vel.x = input_dir.x * speed
	vel.z = input_dir.y * speed
	
	vel.y += gravity * delta
	
	if is_on_floor() and Input.is_action_pressed(jump_action):
		vel.y = jump
	
	vel = move_and_slide(vel, Vector3.UP)
	
func _process(delta):
	if can_rotation_camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

