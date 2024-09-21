class_name Monster
extends Character

@onready var target = closest("Mercenary")

var astar = AStar3D.new()

func _ready():
	if target:
		print("Target found")
		var path = find_path(global_position, target)
		if path:
			print("Moving to target")
			move_along_path(path)

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
	return null

func find_path(start, end):
	var start_id = astar.get_closest_point(start)
	var end_id = astar.get_closest_point(end)
	if start_id == -1 or end_id == -1:
		return []
	return astar.get_point_path(start_id, end_id)

func move_along_path(path):
	for point in path:
		var at = astar.get_point_position(point)
		var direction = (at - global_position).normalized()
		move(direction)

		await get_tree().create_timer(1.0).timeout
