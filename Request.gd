extends Node

func request(node,link):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	node.add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(link)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	print("GOT A RESPONSE!")
	var response = body.get_string_from_utf8()
	#print(response)
	var file = File.new()
	file.open("res://request.tres", file.WRITE)
	file.store_string(response)
	file.close()
	
	MeshGen.delete_mesh()
	MeshGen.load_points_from_grid_file("res://request.tres")
	MeshGen.generate_custom_geometry(MeshGen.TRIANGLE_TYPE_BOTTOM_LEFT)
	MeshGen.generate_custom_geometry(MeshGen.TRIANGLE_TYPE_TOP_RIGHT)


