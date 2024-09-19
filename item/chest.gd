class_name Chest
extends Item

var items = {
	preload("res://item/bomb.tscn"): 0.1,
	preload("res://item/boots.tscn"): 0.1,
	preload("res://item/potion.tscn"): 0.1,
	preload("res://item/gem.tscn"): 0.1,
}

func open():
	$AnimationPlayer.play("Open")

	var item = items.keys()[randi() % items.size()].instantiate()

	item.position = Vector3.UP
	add_child(item)
	if item is Bomb:
		item.explode()

func unlock():
	open()

func _on_body_entered(body):
	if body.has_method("unlock"):
		open()
