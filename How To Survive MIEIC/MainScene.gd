extends Node2D

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_tree().root.get_node("/root/MainScene/Timer")
	timer.start(120)
