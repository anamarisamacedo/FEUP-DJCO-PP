extends Camera2D

onready var target = get_node("/root/Global/Player")
 
func _process (_delta):
	position = target.position

