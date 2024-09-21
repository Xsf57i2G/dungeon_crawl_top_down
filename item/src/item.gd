class_name Item
extends RigidBody3D

var hp = 3

func _physics_process(delta):
	if get_parent().name == "Hand" or get_parent().name == "Back":
		global_transform = get_parent().global_transform
	else:
		rotate_object_local(Vector3.UP, delta)
