extends Area2D

var praxis

func _ready():
	praxis = get_tree().root.get_node("/root/MainScene/NPC_Praxis")

func _on_Beer_body_entered(body):
	if body.name == "Player":
		print(get_tree().root)
		get_tree().queue_delete(self)
		praxis.beerFound = true
