class_name Demon
extends CharacterBody3D

var combo = 0
var carrying = false
var speed = 5.0
var acceleration = 10.0
var damage = 1
var health = 3
var stuned = false
var dead = false
var items = []
var friction = 64.0
var gibs = [
	preload("res://item/gib.tscn"),
]

@onready var yorick = $Yorick
@onready var animation = $Armature/AnimationPlayer
@onready var torso = $Armature/Skeleton3D/Body
@onready var ray = $Armature/Skeleton3D/Body/RayCast3D
@onready var head = $Armature/Skeleton3D/Body/Inventory/Head
@onready var inventory = $Armature/Skeleton3D/Body/Inventory

func _physics_process(delta):
	if dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = 3.0

	if velocity.length() > 5:
		animation.speed_scale = velocity.length() / speed
	else:
		animation.speed_scale = 1.0

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		yorick.look_at(yorick.global_position + direction)
		torso.look_at(position + direction)

		if Input.is_action_pressed("Run"):
			animation.play("Run")
		else:
			animation.play("Walk")

		if is_on_wall():
			if abs(direction.x) < 0.1 or abs(direction.z) < 0.1:
				if $Armature/Skeleton3D/Body/RayCast3D.is_colliding():
					animation.play("Squish")

		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
	else:
		if is_on_floor():
			if velocity.length() > 0.1:
				animation.play("Skid")

		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	if Input.is_action_just_pressed("Throw"):
		throw()
		return
	if Input.is_action_just_pressed("Use"):
		use()
	if Input.is_action_just_pressed("Interact"):
		interact()

	move_and_slide()

func hit(n):
	$Hit.play()

	health -= n
	if health <= 0:
		die()

func use():
	animation.play("Upper Cut")
	var body = ray.get_collider()
	if ray.is_colliding() and body is Character:
		body.hit(damage)
		ray.force_raycast_update()

func heal(n):
	health += n

func die():
	if dead:
		return

	dead = true

	$Death.play()

	for gib in gibs:
		var g = gib.instantiate()
		g.global_position = global_position
		get_parent().add_child(g)

func pose():
	if carrying:
		return

	var poses = [
		"Flex",
	]

	animation.stop()
	torso.look_at(position + global_transform.basis.z)
	animation.play(poses.pick_random())

func interact():
	var bodies = inventory.get_overlapping_bodies()

	for body in bodies:
		if body is Babe or Item and abs(body.position.y - position.y) < 1.0:
			body.reparent(head)
			body.global_transform.origin = head.global_transform.origin
			body.global_transform.basis = head.global_transform.basis
			carrying = true
			if body.has_method("pickup"):
				body.pickup()
			break

	if not bodies:
		pose()

func throw():
	if head.get_child_count() > 0:
		var item = head.get_child(0)
		if item is Babe or Item:
			carrying = false
			item.call_deferred("thrown")
			item.reparent(get_parent())
			item.linear_velocity = velocity.normalized() * 5.0 + Vector3(0, 5, 0)

func _on_animation_player_animation_finished(_anim_name):
	animation.play("Idle")
