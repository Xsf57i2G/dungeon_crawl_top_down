class_name Key
extends Item

func _on_body_entered(body):
	if body.has_method("unlock"):
		body.unlock()
		queue_free()
