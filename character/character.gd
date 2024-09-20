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
