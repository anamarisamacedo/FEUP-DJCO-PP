extends Area2D


# Declare member variables here. Examples:
var praxis

func _ready():
	praxis = get_tree().root.get_node("/root/MainScene/NPC_Praxis")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Beer_body_entered(body):
	if body.name == "Player":
		print(get_tree().root)
		get_tree().queue_delete(self)
		praxis.beerFound = true
