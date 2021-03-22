extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_Continue_pressed():
	get_tree().paused = false
	queue_free()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Restart_pressed():
	get_tree().paused = false
	GlobalVariables.goto_scene("res://MainScene.tscn")
