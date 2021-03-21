extends Camera2D

onready var target = get_node("/root/Outside/Player")
 
func _process (delta):
	position = target.position
