class_name Monster
extends Character

@onready var target = closest("Mercenary")

func _physics_process(_delta):
	var destination = $NavigationAgent3D.get_next_path_position()
	var direction = global_position.direction_to(destination).normalized()
	var new_velocity = direction * speed

	$NavigationAgent3D.set_velocity(new_velocity)

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
		return closest_character

func move(to):
	$NavigationAgent3D.set_target_position(to)

func follow():
	move(target.global_position)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity

	move_and_slide()
