extends Area2D

var player
var current_scene

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).get_name()

func _on_Beer_body_entered(body):
	if body.name == "Player":
		get_tree().root.get_node("/root/"+current_scene+"/Beer").queue_free()
		player.add_beer()
		print(current_scene)
		if current_scene == "MainScene":
			GlobalVariables.beerMainScenePicked = true
		elif current_scene == "FirstHallway":
			GlobalVariables.beerFirstHallwayPicked = true
		elif current_scene == "B130":
			GlobalVariables.beerB130ScenePicked = true
		elif current_scene == "ThirdHallway2":
			GlobalVariables.beerThirdHallway2Picked = true
		elif current_scene == "Outside":
			GlobalVariables.beerOutsidePicked = true
		
