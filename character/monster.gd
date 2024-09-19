class_name Monster
extends Character

var target = null

func _ready():
	wander()

func _physics_process(_delta):
	if $NavigationAgent3D.is_navigation_finished():
		return

	var next_path_position = $NavigationAgent3D.get_next_path_position()
	var new_velocity = position.direction_to(next_path_position) * speed

	if $NavigationAgent3D.is_target_reachable():
		$NavigationAgent3D.set_velocity(new_velocity)

func move(to):
	$NavigationAgent3D.set_target_position(to)

func wander():
	move(Vector3(randi_range(-1, 1), 0, randi_range(-1, 1)))

	move_and_slide()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity

	if safe_velocity == Vector3.ZERO:
		return

	move_and_slide()
