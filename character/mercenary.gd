extends Character

func _input(event):
	if event is InputEventMouseMotion:
		aim()

func _physics_process(delta: float):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		move(direction)
	else:
		move(Vector3.ZERO)

	if Input.is_action_just_pressed("use"):
		var hands = $Torso/Inventory/Hands
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
		var hands = $Torso/Inventory/Hands
		if hands.get_child_count() > 0:
			drop()
		else:
			pickup()

	move_and_slide()

func throw():
	var torso = $Torso
	var hands = $Torso/Inventory/Hands
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		var impulse = (torso.global_transform.basis * Vector3.FORWARD * 2) + (Vector3.UP * 8)
		if item is Item:
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			drop()

func push(delta):
	var collider = get_last_slide_collision()

	if collider:
		var col_collider = collider.get_collider()
		var col_position = collider.get_position()

		if not col_collider is RigidBody3D:
			return

		var push_direction = -collider.get_normal()
		var push_position = col_position - col_collider.global_position
		col_collider.apply_impulse(push_direction * 64 * delta, push_position)

func aim():
	var torso = $Torso
	var camera = $Camera3D
	torso.look_at(camera.aim())
	torso.rotation.x = 0
	torso.rotation.z = 0
