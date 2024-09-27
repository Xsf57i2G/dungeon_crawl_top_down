class_name Consumable
extends Item

var amount = 1

func _on_body_entered(body):
	if body is Character:
		body.collected.emit(1)
