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

	$Model/AnimationPlayer.play("Carry")

	for body in $Model/Armature/Skeleton3D/Body/Inventory.get_overlapping_bodies():
		if body is Babe:
			if not body.carried:
				body.reparent(hands)
				body.look_at(position + global_transform.basis.z)
				body.carried = true
				body.set_identity()
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
		item.position = back.position
		item.reparent(back)
		item.set_identity()
	elif back.get_child_count() > 0:
		var item = back.get_child(0)
		item.position = hand.position
		item.reparent(hand)
		item.set_identity()
