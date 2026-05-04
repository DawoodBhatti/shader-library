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
