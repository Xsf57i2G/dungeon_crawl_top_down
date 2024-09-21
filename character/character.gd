class_name Character
extends CharacterBody3D

signal dropped(item)
signal died

@export var speed = 5.0
@export var damage = 1
@export var health = 3

var gib = preload("res://item/gib.tscn")
var items = []

func hit(n):
	health -= n
	if health <= 0:
		die()

func die():
	died.emit()
	drop()

	var g = gib.instantiate()
	add_child(g)

func move(direction):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func heal(n):
	health += n

func throw():
	var torso = $MeshInstance3D
	var hands = $MeshInstance3D/Inventory/Hand
	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		if item is Item:
			item.freeze = false
			var impulse = (torso.global_transform.basis * Vector3.FORWARD * 10) + (Vector3.UP * 5)
			item.apply_impulse(impulse, Vector3.FORWARD)
			item.reparent(get_parent())
			drop()

func pickup():
	var bodies = $MeshInstance3D/Inventory.get_overlapping_bodies()
	var hands = $MeshInstance3D/Inventory/Hand
	for body in bodies:
		if body is Item:
			if abs(body.position.y - position.y) < 1.0:
				body.reparent(hands)
				body.freeze = true
				break

func drop():
	var hands = $MeshInstance3D/Inventory/Hand
	var back = $MeshInstance3D/Inventory/Back

	if hands.get_child_count() > 0:
		dropped.emit(hands.get_child(0))

	if back.get_child_count() > 0:
		dropped.emit(back.get_child(0))

func swap():
	var hand = $MeshInstance3D/Inventory/Hand
	var back = $MeshInstance3D/Inventory/Back

	if hand.get_child_count() > 0:
		var item = hand.get_child(0)
		item.global_transform.origin = back.global_transform.origin
		item.freeze = true
		item.reparent(back)
	elif back.get_child_count() > 0:
		var item = back.get_child(0)
		item.global_transform.origin = hand.global_transform.origin
		item.freeze = true
		item.reparent(hand)
