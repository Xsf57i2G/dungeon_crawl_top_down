class_name Character
extends CharacterBody3D

signal dropped(item)
signal died

@export var speed = 5.0
@export var damage = 1
@export var health = 3

var unconscious = false
var dead = false
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
	if dead:
		return

	dead = true

	$Death.play()

	died.emit()
	drop()

func move(direction):
	if dead:
		return

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func heal(n):
	health += n

func pickup():
	var hands = $Model/Armature/Skeleton3D/Body/Inventory/Hand
	if hands.get_child_count() > 0:
		return

	var bodies = $Model/Armature/Skeleton3D/Body/Inventory.get_overlapping_bodies()
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

func drop():
	var hands = $Model/Armature/Skeleton3D/Body/Inventory/Hand
	var back = $Model/Armature/Skeleton3D/Body/Inventory/Back
	if hands.get_child_count() > 0:
		dropped.emit(hands.get_child(0))
	if back.get_child_count() > 0:
		dropped.emit(back.get_child(0))

func swap():
	var hand = $Model/Armature/Skeleton3D/Body/Inventory/Hand
	var back = $Model/Armature/Skeleton3D/Body/Inventory/Back

	if hand.get_child_count() > 0:
		var item = hand.get_child(0)
		item.global_transform.origin = back.global_transform.origin
		item.reparent(back)
	elif back.get_child_count() > 0:
		back.get_child(0).global_transform.origin = hand.global_transform.origin
		back.get_child(0).reparent(hand)
