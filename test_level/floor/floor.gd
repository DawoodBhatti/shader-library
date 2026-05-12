extends Node3D

@onready var mesh_instance: MeshInstance3D = $Mesh3D
@onready var static_body: StaticBody3D = $StaticBody3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

#dimensions of floor plane
@export var visible_floor_length: int = 10000

#horizontal dimensions of floor collision shape
@export var solid_floor_length: int = 100

@export var num_squares: int = 5

#vertical dimensions
@export var floor_height: int = 0

# Load the material relative to this folder	
# Preload loads up front but only works if the target file is 'visible' at compile time 
# Load execute at runtime, so it slows game running, but the target file will always be available

@onready var pattern_material: ShaderMaterial = load("res://test_level/floor/materials/pattern_chessboard.tres")
#@onready var pattern_material: ShaderMaterial = load("res://test_level/floor/materials/neon_shader.tres")
#@onready var pattern_material: ShaderMaterial = load("res://test_level/floor/materials/neon_with_grid.tres")


func _ready() -> void:
	_setup_mesh()
	_setup_collision_shape()
	_setup_shader()
	
	
func _setup_shader():

	pattern_material.set_shader_parameter("visible_floor_length", visible_floor_length)
	pattern_material.set_shader_parameter("solid_floor_length", solid_floor_length)
	pattern_material.set_shader_parameter("squares", num_squares)


	#ensure the value we pass here to the shader is an integer 
	assert((solid_floor_length % num_squares) == 0, "solid_floor_length must divide evenly by num_squares")

	pattern_material.set_shader_parameter("square_length", solid_floor_length / num_squares)

	print()
	print("visible_floor_length: ", visible_floor_length)
	print("solid_floor_length: ", solid_floor_length)
	print("square_length: ", solid_floor_length / num_squares)
	print("squares: ", num_squares)
	print("color_1: ", pattern_material.get_shader_parameter("color_1"))
	print("color_2: ", pattern_material.get_shader_parameter("color_2"))
	print()
	

func _setup_mesh() -> void:
	
	#note that uvs for box mesh are wrapped to each cube's side
	#but for a plane mesh they perfectly span 0-1 across the area
	
	
	var plane := PlaneMesh.new()
	plane.size = Vector2(visible_floor_length, visible_floor_length)
	mesh_instance.mesh = plane
	mesh_instance.material_override = pattern_material
	
	print("visible floorplane size: ", plane.size)
	

	
func _setup_collision_shape() -> void:
	var box := BoxShape3D.new()
	box.size = Vector3(solid_floor_length, floor_height, solid_floor_length)
	collision_shape.shape = box
		
	print("collision shape size: ", box.size)

	static_body.collision_layer = 1
	static_body.collision_mask = 1
