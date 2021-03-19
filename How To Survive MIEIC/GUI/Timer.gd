extends Timer

var mainscene

var seconds: int = 0
var minutes: int = 0

var minutes_label
var seconds_label

# Called when the node enters the scene tree for the first time.
func _ready():
	mainscene = get_tree().root.get_node("/root/MainScene")
	minutes_label = get_tree().root.get_node("/root/MainScene/CanvasLayer/Timer/Minutes")
	seconds_label = get_tree().root.get_node("/root/MainScene/CanvasLayer/Timer/Seconds")
	wait_time = 1.0
	connect("timeout", self, "update")
	restart()

func restart():
	seconds = 0
	minutes = 5
	update_labels()
	start()

func update():
	seconds -= 1
	if seconds == -1:
	   seconds = 59
	   minutes -= 1
	if minutes == 0 && seconds == 0:
	   game_over()
	
	update_labels()

func update_labels():
	minutes_label.text = str(minutes)
	if (seconds < 10):
		seconds_label.text = "0" + str(seconds)
	else:
		seconds_label.text = str(seconds)

func stop_time():
	stop()

func game_over():
	mainscene.game_lost()
	stop()
