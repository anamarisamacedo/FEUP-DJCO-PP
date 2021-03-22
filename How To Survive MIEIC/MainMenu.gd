extends CanvasLayer

var timer

func _ready():
	pass

func _on_Quit_pressed():
	get_tree().quit()

func _on_Play_pressed():
	timer = get_tree().root.get_node("/root/Global/Timer")
	timer.start_time()
	get_tree().change_scene("res://MainScene.tscn")
