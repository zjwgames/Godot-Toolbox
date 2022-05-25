extends Area

func _on_Spikes_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
