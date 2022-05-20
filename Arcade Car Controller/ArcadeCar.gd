extends Spatial


# Node references
onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast

# Where to place the car mesh relative to the sphere
var sphere_offset = Vector3(0, 0, 0)
# Engine power
export var acceleration = 50
# Turn amount, in degrees
export var steering = 21.0
# How quickly the car turns
export var turn_speed = 5
# Below this speed, the car doesn't turn
export var turn_stop_limit = 0.75

# Variables for input values
var speed_input = 0
var rotate_input = 0

var body_tilt = 35

func _ready():
	ground_ray.add_exception(ball)

func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + sphere_offset
	# Accelerate based on car's forward direction
	ball.add_central_force(-car_mesh.global_transform.basis.z * speed_input)

func _process(delta):
	# Can't steer/accelerate when in the air
	if not ground_ray.is_colliding():
		return
	# Get accelerate/brake input
	speed_input = 0
	speed_input += Input.get_action_strength("accelerate")
	speed_input -= Input.get_action_strength("brake")
	speed_input *= acceleration
	# Get steering input
	rotate_input = 0
	rotate_input += Input.get_action_strength("steer_left")
	rotate_input -= Input.get_action_strength("steer_right")
	rotate_input *= deg2rad(steering)
	
	# rotate car mesh
	if ball.linear_velocity.length() > turn_stop_limit:
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		car_mesh.rotation.z = lerp(car_mesh.rotation.z, t, 10 * delta)
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
	
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
