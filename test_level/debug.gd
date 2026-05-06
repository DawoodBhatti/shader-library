extends Node



func print_all_nodes(node: Node) -> void:
	# Only nodes with transforms have positions
	if node is Node3D:
		print("%s — %s" % [node.name, node.global_transform.origin])
	elif node is Node2D:
		print("%s — %s" % [node.name, node.global_position])

	# Recurse into children
	for child in node.get_children():
		print_all_nodes(child)



#spawns a single debug sphere and returns the SphereMesh instance
func spawn_debug_sphere(
		position: Vector3 = Vector3.ZERO,
		radius: float = 0.1,
		color: Color = Color(1, 0, 0, 1)
	) -> SphereMesh:

	var sphere_m3d := MeshInstance3D.new()
	var mesh := SphereMesh.new()

	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 32
	mesh.rings = 16

	sphere_m3d.mesh = mesh

	# Simple unshaded material
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sphere_m3d.set_surface_override_material(0, mat)

	# Add to the scene FIRST
	add_child(sphere_m3d)

	# Now it's safe to set global transform
	sphere_m3d.global_transform = Transform3D(Basis(), position)

	return mesh
