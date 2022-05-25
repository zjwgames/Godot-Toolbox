extends Area

var speed = 30
var velocity = Vector3()

func start(xform):
	transform = xform
	velocity = -transform.basis.z * speed

func _process(delta):
	transform.origin += velocity * delta

func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body is StaticBody:
		queue_free()
