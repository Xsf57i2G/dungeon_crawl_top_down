class_name Monster
extends Character

@onready var target = closest("Mercenary")

func _physics_process(_delta):
	if $NavigationAgent3D.is_navigation_finished():
		return

	var next_path_position = $NavigationAgent3D.get_next_path_position()
	var new_velocity = position.direction_to(next_path_position) * speed

	if $NavigationAgent3D.is_target_reachable():
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

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	
	if safe_velocity == Vector3.ZERO:
		return

	move_and_slide()
