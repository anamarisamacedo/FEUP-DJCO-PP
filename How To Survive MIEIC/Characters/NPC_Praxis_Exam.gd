extends KinematicBody2D

var dialogue_state = 0
var beerFound = false
var dialoguePopup
var player
var alreadyTalked = false

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(_answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Mark Zuckerberg"
	
	match dialogue_state:
		0:
			if alreadyTalked == false:
				player.talked_to_student()
				alreadyTalked = true
			dialogue_state = 1
			dialoguePopup.dialogue = "Shushhh. Let me do my exam!"
			dialoguePopup.answers = "[A] Sorry. Bye"
			dialoguePopup.open()
		1:
			dialogue_state = 0
			dialoguePopup.close()
