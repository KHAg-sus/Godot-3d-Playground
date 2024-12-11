extends RigidBody3D

signal player_interact

var mouse_sensitivity := 0.005
var twist_input := 0.0
var pitch_input := 0.0
var JUMP_FORCE := 10.0
var velocity = Vector3.ZERO
var sitting: bool = false

@onready var Couch: StaticBody3D = %Couch
@onready var ray_cast1 = $Raycasts/R1
@onready var ray_cast2 = $Raycasts/R2
@onready var ray_cast3 = $Raycasts/R3
@onready var ray_cast4 = $Raycasts/R4
@onready var ray_cast5 = $Raycasts/R5

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_down")
	
	if sitting:
		input = Vector3(0, 0, 0)
	if Input.is_action_just_pressed("ui_interact"):
		player_interact.emit()
	if input.length() > 1:
		input = input.normalized()
	
	if is_on_floor():
		apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	else:
		apply_central_force(twist_pivot.basis * input * 600.0 * delta)
		
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
		linear_velocity = velocity
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0

func is_on_floor() -> bool:
	return (ray_cast1.is_colliding() or ray_cast2.is_colliding() or
	 ray_cast3.is_colliding() or ray_cast4.is_colliding() or ray_cast5.is_colliding())

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func sit_on_couch():
	position = Couch.global_position + Vector3(0, 1, -0.2)
	freeze = true
	sitting = true

func stand_up():
	freeze = false
	sitting = false
