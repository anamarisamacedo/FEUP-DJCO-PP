extends CanvasLayer

onready var subtitle = $PanelContainer/MarginContainer/Rows/Subtitle

func set_title(win: bool):
	if win:
		subtitle.text = "YOU WIN!"
		subtitle.modulate = Color.green
	else:
		subtitle.text = "YOU LOSE!"
		subtitle.modulate = Color.red

func _on_Restart_pressed():
	get_tree().paused = false
	GlobalVariables.goto_scene("res://MainScene.tscn")


func _on_Quit_pressed():
	get_tree().quit()
