class_name Character
extends CharacterBody3D

signal dropped(item)
signal died

@export var speed = 5.0
@export var damage = 1
@export var health = 3

var dead = false
var gib = preload("res://item/gib.tscn")
var items = []

func _process(_delta):
	if dead:
		return

func hit(n):
	$Hit.play()

	health -= n
	if health <= 0:
		die()

func die():
	dead = true

	$Death.play()

	died.emit()
	drop()

	var g = gib.instantiate()
	add_child(g)

func move(direction):
	if dead:
		return

	if direction:
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.stop()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func heal(n):
	health += n

func throw():
	var torso = $Armature/Skeleton3D/MeshInstance3D
	var hands = $Armature/Skeleton3D/MeshInstance3D/Inventory/Hand
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		if item is Character:
			item.reparent(get_parent())
			drop()
		if item is Item:
			var impulse = (torso.global_transform.basis * Vector3.FORWARD * 4) + (Vector3.UP * 4)
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			drop()

func pickup():
	var hands = $Armature/Skeleton3D/MeshInstance3D/Inventory/Hand
	if hands.get_child_count() > 0:
		return # Exit if there's already an item in hand

	var bodies = $Armature/Skeleton3D/MeshInstance3D/Inventory.get_overlapping_bodies()
	for body in bodies:
		if body is Character:
			var forward_self = global_transform.basis.z
			var forward_body = body.global_transform.basis.z
			if forward_self.dot(forward_body) > 0.5 and abs(body.position.y - position.y) < 1.0:
				body.reparent(hands)
				break
		if body is Item:
			if abs(body.position.y - position.y) < 1.0:
				body.reparent(hands)

func jump():
	if dead:
		return

func drop():
	var hands = $Armature/Skeleton3D/MeshInstance3D/Inventory/Hand
	var back = $Armature/Skeleton3D/MeshInstance3D/Inventory/Back
	if hands.get_child_count() > 0:
		dropped.emit(hands.get_child(0))
	if back.get_child_count() > 0:
		dropped.emit(back.get_child(0))

func swap():
	var hand = $Armature/Skeleton3D/MeshInstance3D/Inventory/Hand
	var back = $Armature/Skeleton3D/MeshInstance3D/Inventory/Back

	if hand.get_child_count() > 0:
		var item = hand.get_child(0)
		item.global_transform.origin = back.global_transform.origin
		item.reparent(back)
	elif back.get_child_count() > 0:
		back.get_child(0).global_transform.origin = hand.global_transform.origin
		back.get_child(0).reparent(hand)
