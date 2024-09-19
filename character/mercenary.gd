extends Character

func _input(event):
	if event is InputEventMouseMotion:
		aim()

func _physics_process(delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		move(direction)
	else:
		move(Vector3.ZERO)

	if Input.is_action_just_pressed("use"):
		if $Torso/Inventory/Hands.get_child_count() > 0:
			var item = $Torso/Inventory/Hands.get_child(0)
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
		if $Torso/Inventory/Hands.get_child_count() > 0:
			drop()
		else:
			pickup()

	push(delta)
	move_and_slide()

func throw():
	var hands = $Torso/Inventory/Hands
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		var throw_impulse = ($Torso.global_transform.basis * Vector3.FORWARD * 5) + (Vector3.UP * 10)
		item.apply_impulse(throw_impulse, Vector3.FORWARD)
		item.reparent(get_parent())
		drop()

func push(delta):
	var col = get_last_slide_collision()

	if col:
		var col_collider = col.get_collider()
		var col_position = col.get_position()

		if not col_collider is RigidBody3D:
			return

		var push_direction = -col.get_normal()
		var push_position = col_position - col_collider.global_position
		col_collider.apply_impulse(push_direction * 128 * delta, push_position)

func aim():
	$Torso.look_at($Camera3D.aim())
	$Torso.rotation.x = 0
	$Torso.rotation.z = 0
