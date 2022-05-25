extends KinematicBody

var gravity = Vector3.DOWN * 12  # strength of gravity
var speed = 10 # movement speed
var jump_speed = 6  # jump strength
var spin = 0.1  # rotation speed

var velocity = Vector3.ZERO
var jump = false

var Bullet = preload("res://Bullet.tscn")

var can_move = true

func take_damage():
	velocity *= -1
	velocity.y = jump_speed
	can_move = false
	yield(get_tree().create_timer(1), "timeout")
	can_move = true

func get_input():
	if !can_move:
		return
	var vy = velocity.y
	velocity = Vector3()
	if Input.is_action_pressed("move_forward"):
		if !is_on_floor() or $RayCast.is_colliding():
			velocity += -transform.basis.z * speed
	if Input.is_action_pressed("move_back"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("strafe_right"):
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("strafe_left"):
		velocity += -transform.basis.x * speed
	velocity.y = vy
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true

func _physics_process(delta):
	velocity += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	if jump and is_on_floor():
		velocity.y = jump_speed

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		var b = Bullet.instance()
		b.start($Muzzle.global_transform)
		get_parent().add_child(b)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event.relative.x > 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))
		elif event.relative.x < 0:
			rotate_y(-lerp(0, spin, event.relative.x/10))
