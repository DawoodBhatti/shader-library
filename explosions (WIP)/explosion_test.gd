extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var mat := mesh.get_active_material(0)

var t := 0.0

func _process(delta):
	t += delta

	mat.set_shader_parameter("explosion_time", t)
	mat.set_shader_parameter("dissolve_amount", clamp(t * 0.4, 0.0, 1.0))
	mat.set_shader_parameter("explosion_size", 1.0 + t * 2.0)

	if t > 2.0:
		queue_free()
