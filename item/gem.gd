class_name Gem
extends Item

func _ready():
	scale = Vector3(randf_range(0.5, 1.5), randf_range(0.5, 1.5), randf_range(0.5, 1.5))

func _on_body_entered(body: Node):
	if body.has_method("pickup"):
		queue_free()
