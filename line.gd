extends Node3D

func _ready():
	draw(Vector3(0, 0, 0), Vector3(0, 0,1))

func draw(a, b):
	if a.is_equal_approx(b):
		return

	var mesh_instance = MeshInstance3D.new()

	mesh_instance.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh_instance.mesh.surface_add_vertex(a)
	mesh_instance.mesh.surface_add_vertex(b)
	mesh_instance.mesh.surface_end()
