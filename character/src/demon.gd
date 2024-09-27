class_name Demon
extends Character

signal collected(amount)

var combo = 0
var acceleration = 5.0
var friction = 5.0
var max_speed = 10.0

func _ready():
	$Model/AnimationPlayer.play("Run1")

func _physics_process(delta):
	if dead:
		return

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		$Skull.look_at($Skull.global_position + -direction)
		$Model/Armature/Skeleton3D/Body.look_at(position + direction)

		move(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)
		$Dust.emitting = false
		$Model/AnimationPlayer.play("Idle")

	if $Model/Armature/Skeleton3D/Body/Inventory/Hand.get_child_count() > 0:
		$Model/AnimationPlayer.play("Carry")
	else:
		if Input.is_action_just_pressed("sprint"):
			speed *= 1.5
			$Model/AnimationPlayer.play("Run2")
			$Model/AnimationPlayer.speed_scale = 4
		elif Input.is_action_just_released("sprint"):
			speed = 5.0
			$Dust.emitting = true
			$Model/AnimationPlayer.play("Run1")
			$Model/AnimationPlayer.speed_scale = 3.5

	var hands = $Model/Armature/Skeleton3D/Body/Inventory/Hand
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		if item.has_method("use"):
			item.use()
	else:
		if Input.is_action_just_pressed("use"):
			punch()

	if Input.is_action_just_pressed("throw"):
		throw()

	if Input.is_action_just_pressed("swap"):
		swap()

	if Input.is_action_just_pressed("interact"):
		pickup()

	move_and_slide()

func punch():
	if dead:
		return

	$Model/AnimationPlayer.stop()
	$Model/AnimationPlayer.play("Punch")

func throw():
	$Model/AnimationPlayer.stop()
	$Model/AnimationPlayer.play("Kick")

	var torso = $Model/Armature/Skeleton3D/Body
	var hands = $Model/Armature/Skeleton3D/Body/Inventory/Hand
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		if item is Character:
			item.reparent(get_parent())
			drop()
		if item is Item:
			var impulse = (torso.global_transform.basis * Vector3.FORWARD * 10) + (Vector3.UP * 4)
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			drop()

func aim():
	if dead:
		return

	var a = $Camera3D.aim()
	$Model/Armature/Skeleton3D/Body.look_at(a)

	var rotation_y = $Model/Armature/Skeleton3D/Body.rotation.y
	var increment = deg_to_rad(45)
	rotation_y = round(rotation_y / increment) * increment

	$Model/Armature/Skeleton3D/Body.rotation.y = rotation_y
	$Model/Armature/Skeleton3D/Body.rotation.x = 0
	$Model/Armature/Skeleton3D/Body.rotation.z = 0

func _on_swing_timeout():
	combo = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
