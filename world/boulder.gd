extends RigidBody3D

func _physics_process(_delta):
	roll(Vector3.FORWARD)

func roll(direction):
	position += direction

	rotate_y(0.1)

func crush(body):
	if body.has_method("hit"):
		body.hit(10)
