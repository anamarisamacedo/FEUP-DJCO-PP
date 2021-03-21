extends Camera2D

onready var target = get_node("/root/Library2/Player")
 
func _process (delta):
	position = target.position
