extends Node2D

var player

func _ready():
	player = get_tree().root.get_node("/root/Global/Player")
	player.position = $Position2D.position
	if GlobalVariables.quest_status_praxis_project != GlobalVariables.QuestStatus.PROJECT:
		get_tree().root.get_node("/root/Outside/NPC_Praxis_project").queue_free()

func _on_Shelf2_body_entered(body):
	if body.name == "Player":
		if(GlobalVariables.bookB031Found == false):
			GlobalVariables.bookB031Found = true
			$AnimationPlayer.play("Book")
			player.add_book()


func _on_back_body_entered(body):
	if body.name == "Player":
		GlobalVariables.goto_scene("res://Hallways/ThirdHallway.tscn")

