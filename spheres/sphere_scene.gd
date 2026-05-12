extends Node3D
@onready var sphere_surface_mat = $MeshInstance3D.get_active_material(0)

var noise_size : float = 0.001
var time_offset : float = 0.001

#TODO
#"make the globe shader with ripples and bonus delauney trianglation/voronoi cell wrapped over the surface"
#"bonus todo: find the boids compute shader accidental optimisatino"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#moving sphere scene close to origin
#	position = Vector3(0,25,0)
	
	#sphere_surface_mat.set_shader_parameter("NoiseSize", 1.0)
	#
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#let's update the noise on the sphere to create a wobble effect
	
	#sphere_surface_mat.set_shader_parameter("NoiseSize", noise_size)
	#noise_size += 0.0001
	#
	#sphere_surface_mat.set_shader_parameter("TimeOffset", time_offset)
	#time_offset += 0.005
	pass
