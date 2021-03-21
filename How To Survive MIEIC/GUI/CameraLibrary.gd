extends Camera2D

onready var target = get_node("/root/Library/Player")
 
func _process (delta):
	position = target.position
