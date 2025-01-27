extends Timer

var player

var seconds: int = 0
var minutes: int = 0

var minutes_label
var seconds_label

# Called when the node enters the scene tree for the first time.
func _ready():
	minutes_label = get_tree().root.get_node("/root/Global/CanvasLayer/Timer/Minutes")
	seconds_label = get_tree().root.get_node("/root/Global/CanvasLayer/Timer/Seconds")
	player = get_tree().root.get_node("/root/Global/Player")

func restart():
	seconds = 0
	minutes = 10
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
	player.game_lost()
	stop()
 
func start_time():
	wait_time = 1.0
# warning-ignore:return_value_discarded
	connect("timeout", self, "update")
	restart()
