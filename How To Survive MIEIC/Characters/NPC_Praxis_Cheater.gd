extends KinematicBody2D

enum QuestStatus { NOT_STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var beerFound = false
var dialoguePopup
var player

# Random number generator
var rng = RandomNumberGenerator.new()

var alreadyTalked = false

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Mark Zuckerberg"
	
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if alreadyTalked == false:
						player.talked_to_student()
						alreadyTalked = true
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hey! What do you want?"
					dialoguePopup.answers = "[A] Can you help me cheat?  [B] Nothing. I'm cool!"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "I'll do it for 5 beers..."
							dialoguePopup.answers = "[A] Ok. Here are they. [B] I'm good then."
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Why did you distract me then?"
							dialoguePopup.answers = "[A] Ups! Bye."
							dialoguePopup.open()
				2:
					match answer:
						"A":
							dialogue_state = 3
							
							if player.number_beers >= 5:
								dialoguePopup.dialogue = "Here are my answers. Now let me finish this."
								dialoguePopup.answers = "[A] Thank you. Bye."
								dialoguePopup.open()
								player.remove_beer(5)
								player.cheat()
								quest_status = QuestStatus.COMPLETED
							else:
								dialoguePopup.dialogue = "You don't have enough beers, bro! Come back when you do."
								dialoguePopup.answers = "[A] Sorry. Bye."
								dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Do as you please. Just let me finish this test."
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "I've already given you the answer. Let me finish this exam."
					dialoguePopup.answers = "[A] Sorry. Bye."
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
