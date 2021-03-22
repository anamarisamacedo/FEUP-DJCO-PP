extends Node2D

var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_FirstHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/FirstHallway.tscn")

func _on_SecondHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/SecondHallway.tscn")


func _on_ThirdHallway_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Hallways/ThirdHallway.tscn")


func _on_OutsideDoor_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Outside.tscn")
