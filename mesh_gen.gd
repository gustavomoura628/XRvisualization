extends Node

var point_array:Array

const SQUARE_SIZE = 0.04
const VERTICAL_SCALING_FACTOR = 3.5
const VERTICAL_OFFSET = 0.5

var grid_width
var grid_height

const TRIANGLE_TYPE_BOTTOM_LEFT = 0
const TRIANGLE_TYPE_TOP_RIGHT = 1

var MESH_BOTTOM_LEFT = null
var MESH_TOP_RIGHT = null

func load_points_from_grid_file(file_path: String):
	point_array.clear()
	grid_width = 0
	grid_height = 0
	var file = File.new()
	file.open(file_path, file.READ)

	var x = 0
	var z = 0

	while not file.eof_reached():
		var line = file.get_csv_line()

		var valid_line = false

		for value in line:
			if value == "" or value == " ":
				break

			valid_line = true

			var point = Vector3(x,VERTICAL_SCALING_FACTOR*SQUARE_SIZE*float(value)+VERTICAL_OFFSET,z)
			point_array.append(point)

			if grid_height == 0:
				grid_width = grid_width + 1

			x = x + SQUARE_SIZE

		z = z + SQUARE_SIZE
		x = 0

		if valid_line:
			grid_height = grid_height + 1
	print("Array Size = ",point_array.size())
	
func add_triangle_to_grid_geometry(geo, x, y, grid, width, triangle_type):
	var t = triangle_type
	if t != TRIANGLE_TYPE_BOTTOM_LEFT and t != TRIANGLE_TYPE_TOP_RIGHT:
		print("ERROR: Incorrect Triangle Type!")
		get_tree().quit()

	#triangle facing direction 1
	geo.add_vertex(grid[(x+t)+(y+t)*width])
	geo.add_vertex(grid[(x+1)+(y) * width])
	geo.add_vertex(grid[(x)  +(y+1)*width])

	#triangle facing direction 2
	geo.add_vertex(grid[(x)+  (y+1)*width])
	geo.add_vertex(grid[(x+1)+(y) * width])
	geo.add_vertex(grid[(x+t)+(y+t)*width])

	#Note: Triangle Type flips direction, but as we cover both it doesn't matter

func generate_custom_geometry(triangle_type) -> ImmediateGeometry:
	if triangle_type != TRIANGLE_TYPE_BOTTOM_LEFT and triangle_type != TRIANGLE_TYPE_TOP_RIGHT:
		print("ERROR: Incorrect Triangle Type!")
		get_tree().quit()


	var immediate_geometry := ImmediateGeometry.new()
	var material := SpatialMaterial.new()
	
	immediate_geometry.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_ON

	if triangle_type == TRIANGLE_TYPE_TOP_RIGHT:
		material.albedo_color = Color(0.5,0.5,0.5)
	elif triangle_type == TRIANGLE_TYPE_BOTTOM_LEFT:
		material.albedo_color = Color(0.3,0.3,0.3)

	immediate_geometry.material_override = material
	immediate_geometry.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(grid_height-1):
		for j in range(grid_width-1):
			add_triangle_to_grid_geometry(immediate_geometry,j,i,point_array,grid_width,triangle_type)
	immediate_geometry.end()

	get_tree().get_root().add_child(immediate_geometry)
	if triangle_type == TRIANGLE_TYPE_TOP_RIGHT:
		MESH_TOP_RIGHT = immediate_geometry
	elif triangle_type == TRIANGLE_TYPE_BOTTOM_LEFT:
		MESH_BOTTOM_LEFT = immediate_geometry
		
	return immediate_geometry

func delete_mesh():
	if MESH_BOTTOM_LEFT != null:
		MESH_BOTTOM_LEFT.queue_free()
		MESH_BOTTOM_LEFT = null
	if MESH_TOP_RIGHT != null:
		MESH_TOP_RIGHT.queue_free()
		MESH_TOP_RIGHT = null
