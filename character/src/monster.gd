class_name Monster
extends Character

@onready var target = closest("Mercenary")

var astar = AStarGrid2D.new()

func _process(_delta):
	target = closest("Mercenary")

	astar.size = Vector2i(32, 32)
	astar.cell_size = Vector2i(32, 32)
	astar.update()

func closest(group):
	var characters = get_tree().get_nodes_in_group(group)
	var closest_character = null
	var closest_distance = INF

	for c in characters:
		var distance = global_position.distance_to(c.global_position)
		if distance < closest_distance:
			closest_character = c
			closest_distance = distance

	if closest_character and closest_character is Character:
		return closest_character.global_position
