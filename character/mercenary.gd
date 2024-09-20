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
		var collider = $Torso/RayCast3D.get_collider()
		if collider:
			if collider.has_method("hit"):
				collider.hit(10)

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

func pickup():
	var bodies = $Torso/Inventory.get_overlapping_bodies()
	var hands = $Torso/Inventory/Hands
	for body in bodies:
		if body is Item:
			if abs(body.position.y - position.y) < 1.0:
				body.reparent(hands)
				break

func throw():
	var torso = $Torso
	var hands = $Torso/Inventory/Hands
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		if item is Item:
			var impulse = (torso.global_transform.basis * Vector3.FORWARD * 10) + (Vector3.UP * 5)
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			drop()

func aim():
	$Torso.look_at($Camera3D.aim())
	$Torso.rotation.x = 0
	$Torso.rotation.z = 0
