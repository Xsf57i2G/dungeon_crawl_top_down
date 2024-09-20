class_name Key
extends Item

func _ready():
	var colors = [
		Color.RED,
		Color.GREEN,
		Color.BLUE,
		Color.YELLOW,
	]
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_color = colors.pick_random()

func _on_body_entered(body):
	if body.has_method("unlock"):
		body.unlock()
		queue_free()
