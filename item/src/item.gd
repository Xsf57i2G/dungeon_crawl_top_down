class_name Item
extends RigidBody3D

@export var spin = false

var hp = 3

func _ready():
	rotation.y = randi_range(0, 360)

func _physics_process(delta):
	if spin:
		rotate_object_local(Vector3.UP, delta)

	linear_velocity.y = 0