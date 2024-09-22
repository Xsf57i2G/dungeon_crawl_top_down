class_name Mercenary
extends Character

func _input(event):
	if event is InputEventMouseMotion:
		aim()

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		move(direction)
	else:
		move(Vector3.ZERO)

	if Input.is_action_just_pressed("use"):
		var hands = $MeshInstance3D/Inventory/Hand
		if hands.get_child_count() > 0:
			var item = hands.get_child(0)
			if item.has_method("use"):
				item.use()

	if Input.is_action_just_pressed("jump"):
		if not is_on_floor():
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed("throw"):
		throw()

	if Input.is_action_just_pressed("swap"):
		swap()

	if Input.is_action_just_pressed("interact"):
		pickup()

	move_and_slide()

func aim():
	if dead:
		return

	var a = $Camera3D.aim()
	$MeshInstance3D.look_at(a)

	var rotation_y = $MeshInstance3D.rotation.y
	var increment = deg_to_rad(45)
	rotation_y = round(rotation_y / increment) * increment

	$MeshInstance3D.rotation.y = rotation_y
	$MeshInstance3D.rotation.x = 0
	$MeshInstance3D.rotation.z = 0
