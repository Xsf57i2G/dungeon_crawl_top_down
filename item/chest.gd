class_name Chest
extends Item

var closed := true
var items := {
	preload("res://item/bomb.tscn"): 0.1,
	preload("res://item/boots.tscn"): 0.1,
	preload("res://item/potion.tscn"): 0.1,
}

func open():
	closed = false

	$AnimationPlayer.play("Open")

	var item = items.keys()[randi() % items.size()]
	var v = item.instantiate()
	v.position = Vector3.UP
	add_child(v)

func _on_body_entered(_body: Node):
	open()
