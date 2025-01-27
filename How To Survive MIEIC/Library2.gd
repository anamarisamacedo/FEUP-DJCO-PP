extends Node2D

var player 

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.beerLibrary2Picked == true:
		get_tree().root.get_node("/root/Library2/Beer").queue_free()
		
func _on_elevator_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Library.tscn")
		GlobalVariables.player_position = GlobalVariables.Player_positions.LIBRARY2_BACK_POSITION

func _on_shelfBook_body_entered(body):
	if body.name == "Player":
		if(GlobalVariables.bookLibrary2Found == false):
			GlobalVariables.bookLibrary2Found = true
			$AnimationPlayer.play("Book")
			player.add_book()

func key_found():
	$AnimationPlayer2.play("Key")
