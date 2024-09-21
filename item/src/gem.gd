class_name Consumable
extends Item

func _on_body_entered(body):
	if body is Character:
		queue_free()
