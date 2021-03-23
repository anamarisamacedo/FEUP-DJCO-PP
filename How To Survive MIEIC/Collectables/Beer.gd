extends Area2D

var player
var current_scene

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	current_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count()-1).get_name()

func _on_Beer_body_entered(body):
	if body.name == "Player":
		if current_scene == "MainScene":
			get_tree().root.get_node("/root/"+current_scene+"/Collectables/"+self.name).queue_free()
			player.add_beer()
			if self.name == "Beer":
				GlobalVariables.beerMainScenePicked = true
			elif self.name == "Beer2":
				GlobalVariables.beer2MainScenePicked = true
			elif self.name == "Beer3":
				GlobalVariables.beer3MainScenePicked = true
			elif self.name == "Beer4":
				GlobalVariables.beer4MainScenePicked = true
			elif self.name == "Beer5":
				GlobalVariables.beer5MainScenePicked = true
		else:
			get_tree().root.get_node("/root/"+current_scene+"/"+ self.name).queue_free()
			player.add_beer()
			if current_scene == "FirstHallway":
				GlobalVariables.beerFirstHallwayPicked = true
			elif current_scene == "SecondHallway":
				GlobalVariables.beerSecondHallwayPicked = true
			elif current_scene == "ThirdHallway":
				GlobalVariables.beerThirdHallwayPicked = true
			elif current_scene == "B130":
				GlobalVariables.beerB130ScenePicked = true
			elif current_scene == "ThirdHallway2":
				GlobalVariables.beerThirdHallway2Picked = true
			elif current_scene == "Outside":
				if self.name == "Beer":
					GlobalVariables.beerOutsidePicked = true
				elif self.name == "Beer2":
					GlobalVariables.beerOutside2Picked = true
			elif current_scene == "Library":
				GlobalVariables.beerLibraryPicked = true
			elif current_scene == "Library2":
				GlobalVariables.beerLibrary2Picked = true
		
