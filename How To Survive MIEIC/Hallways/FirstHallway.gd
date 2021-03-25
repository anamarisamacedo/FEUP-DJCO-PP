extends Node2D

var player
var back_position

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.beerFirstHallwayPicked == true:
		get_tree().root.get_node("/root/FirstHallway/Beer").queue_free()

func _on_Back_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://MainScene.tscn")
		GlobalVariables.player_position = GlobalVariables.Player_positions.FIRST_BACK_POSITION


func _on_Door1_body_entered(body):
	if body.name == "Player":
		if player.b010key == true:
			GlobalVariables.goto_scene("res://Hallways/Rooms/B010Scene.tscn")
		else:
			$AnimationPlayer.play("NeedKey")


func _on_Door2_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/Rooms/B011Scene.tscn")

