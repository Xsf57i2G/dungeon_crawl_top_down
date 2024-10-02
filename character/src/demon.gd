class_name Demon
extends Character

var posing = false
var acceleration = 1.0
var friction = 16.0
var gibs = [
	preload("res://item/gib.tscn"),
	preload("res://item/body.tscn"),
]

func _physics_process(delta):
	if dead:
		return

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		$Skull.look_at($Skull.global_position + -direction)
		$Demon/Armature/Skeleton3D/Body.look_at(position + direction)

		if Input.is_action_just_pressed("Run"):
			$Demon/AnimationPlayer.play("Run")
			acceleration = 2.0
		else:
			$Demon/AnimationPlayer.play("Walk")
			acceleration = 1.0

		if is_on_wall():
			if abs(direction.x) < 0.1 or abs(direction.z) < 0.1:
				$Demon/AnimationPlayer.play("Squish")

		move(direction)
	else:
		if velocity.length() > 0:
			$Demon/AnimationPlayer.play("Skid")

		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	if Input.is_action_just_pressed("throw"):
		throw()

	if Input.is_action_just_pressed("swap"):
		swap()

	if Input.is_action_just_pressed("interact"):
		pickup()

	move_and_slide()

func die():
	if dead:
		return

	super()

	for gib in gibs:
		var g = gib.instantiate()
		g.global_position = global_position
		get_parent().add_child(g)

func pose():
	var poses = [
		"Flex"
	]

	$Demon/Armature/Skeleton3D/Body.look_at(position + global_transform.basis.z)
	$Demon/AnimationPlayer.play(poses.pick_random())
	$Pose.play()

func punch():
	if dead:
		return

	$Demon/AnimationPlayer.stop()
	$Demon/AnimationPlayer.play("Punch")

func pickup():
	var hand = $Demon/Armature/Skeleton3D/Body/Inventory/Hand
	var bodies = $Demon/Armature/Skeleton3D/Body/Inventory.get_overlapping_bodies()

	for body in bodies:
		if abs(body.position.y - position.y) < 1.0:
			if body is Babe or Item:
				$Demon/AnimationPlayer.play("Carry")
				body.reparent(hand)
				body.global_transform = hand.global_transform
				if body.has_method("pickup"):
					body.pickup()
				break
			if body is Goblin:
				health -= 1
				break
			else:
				pose()

func throw():
	var hand = $Demon/Armature/Skeleton3D/Body/Inventory/Hand

	if hand.get_child_count() > 0:
		var item = hand.get_child(0)
		if item is Item or Babe:
			var impulse = (hand.global_transform.basis * Vector3.FORWARD * 10) + (Vector3.UP * 4)
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			if item.has_method("throw"):
				item.throw()
			drop()

func drop():
	var hands = $Demon/Armature/Skeleton3D/Body/Inventory/Hand
	var back = $Demon/Armature/Skeleton3D/Body/Inventory/Back
	if hands.get_child_count() > 0:
		dropped.emit(hands.get_child(0))
	if back.get_child_count() > 0:
		dropped.emit(back.get_child(0))

func swap():
	var hand = $Demon/Armature/Skeleton3D/Body/Inventory/Hand
	var back = $Demon/Armature/Skeleton3D/Body/Inventory/Back

	if hand.get_child_count() > 0:
		var item = hand.get_child(0)
		item.position = back.position
		item.reparent(back)
		item.set_identity()
	elif back.get_child_count() > 0:
		var item = back.get_child(0)
		item.position = hand.position
		item.reparent(hand)
		item.set_identity()

func _on_animation_player_animation_finished(_anim_name):
	$Demon/AnimationPlayer.play("Idle")
