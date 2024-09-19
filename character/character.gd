class_name Character
extends CharacterBody3D

signal dropped(item: Node)
signal died

var damage := 1
var health := 3
var items := []
var speed := 5.0
var gib := preload("res://item/gib.tscn")

func hit(n: int):
	health -= n
	if health <= 0:
		die()

func die():
	died.emit()
	drop()

	var g = gib.instantiate()
	add_child(g)

func move(direction: Vector3):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func heal(n: int):
	health += n

func pickup():
	var bodies = $Torso/Inventory.get_overlapping_bodies()
	for body in bodies:
		if body is Item:
			body.reparent($Torso/Inventory/Hands)
			body.position = Vector3.FORWARD
			break

func drop():
	var hands = $Torso/Inventory/Hands
	var back = $Torso/Inventory/Back

	if hands.get_child_count() > 0:
		dropped.emit(hands.get_child(0))

	if back.get_child_count() > 0:
		dropped.emit(back.get_child(0))

func swap():
	var hands = $Torso/Inventory/Hands
	var back = $Torso/Inventory/Back

	if hands.get_child_count() > 0:
		var item = hands.get_child(0)
		item.reparent(back)

	if back.get_child_count() > 0:
		var item = back.get_child(0)
		item.reparent(hands)
