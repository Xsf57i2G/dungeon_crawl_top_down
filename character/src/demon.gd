class_name Demon
extends Character

func _input(event):
	if event is InputEventMouseMotion:
		aim()

func _physics_process(delta):
	if dead:
		return

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		move(direction)

		$Armature/Skeleton3D/MeshInstance3D.look_at(position + direction)
	else:
		move(Vector3.ZERO)

	if Input.is_action_just_pressed("use"):
		var hands = $Armature/Skeleton3D/MeshInstance3D/Inventory/Hand
		if hands.get_child_count() > 0:
			var item = hands.get_child(0)
			if item.has_method("use"):
				item.use()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			print("jump")
			velocity += get_gravity() * delta

	if Input.is_action_just_pressed("throw"):
		throw()

	if Input.is_action_just_pressed("swap"):
		swap()

	if Input.is_action_just_pressed("interact"):
		pickup()

	if Input.is_action_just_pressed("sprint"):
		speed = 10
	else:
		speed = 5

	move_and_slide()

func aim():
	if dead:
		return

	var a = $Camera3D.aim()
	$Armature/Skeleton3D/MeshInstance3D.look_at(a)

	var rotation_y = $Armature/Skeleton3D/MeshInstance3D.rotation.y
	var increment = deg_to_rad(45)
	rotation_y = round(rotation_y / increment) * increment

	$Armature/Skeleton3D/MeshInstance3D.rotation.y = rotation_y
	$Armature/Skeleton3D/MeshInstance3D.rotation.x = 0
	$Armature/Skeleton3D/MeshInstance3D.rotation.z = 0

func punch():
	if dead:
		return

	if $RayCast3D.is_colliding():
		var collider = $RayCast3D.get_collider()
		if collider.has_method("hit"):
			collider.hit(1)
