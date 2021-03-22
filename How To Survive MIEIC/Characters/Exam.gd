extends Area2D

var did_exam = false
var dialogue_state = 0
var dialoguePopup
var player
var correct_answers = 0

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Mark Zuckerberg"
	
	match dialogue_state:
		0:
			if did_exam:
				dialogue_state = 12
				dialoguePopup.dialogue = "You already did this exam."
				dialoguePopup.answers = "[A] Bye then."
			else:
				dialogue_state = 1
				dialoguePopup.dialogue = "Hello Student! Welcome to the Final DJCO Exam. You only have one shot at completing the exam. Do you wish to begin now?"
				dialoguePopup.answers = "[A] I'm ready to start. [B] I want to study more before taking the exam."
			dialoguePopup.open()
		1:
			if answer == "A":
				did_exam = true
				dialogue_state = 2
				# Show dialogue popup
				dialoguePopup.dialogue = "1. Which of the following is NOT a part of the Elemental Tetrad?"
				dialoguePopup.answers = "[A] Aesthetics  [B] Mechanics  [C] Villains  [D] Story"
				dialoguePopup.open()

			else:
				# Update dialogue tree state
				dialogue_state = 12
				# Show dialogue popup
				dialoguePopup.dialogue = "Come back when you're ready."
				dialoguePopup.answers = "Ok bye"
				dialoguePopup.open()
		2:
			print("hello")
			if answer == "C":
				correct_answers += 1
			dialogue_state = 3
			# Show dialogue popup
			dialoguePopup.dialogue = "2. A Game is a:"
			dialoguePopup.answers = "[A] Form of Art  [B] Experience  [C] All of the above  [D] None of the above"
			dialoguePopup.open()
		3:
			if answer == "C":
				correct_answers += 1
			dialogue_state = 4
			# Show dialogue popup
			dialoguePopup.dialogue = "3. Adult Women represent a portion of video game-playing population of: "
			dialoguePopup.answers = "[A] 0  [B] 9  [C] 26  [D] 33"
			dialoguePopup.open()
		4:
			if answer == "D":
				correct_answers += 1
			dialogue_state = 5
			# Show dialogue popup
			dialoguePopup.dialogue = "4. Which of the following has a bigger influence in the game buying decision process?"
			dialoguePopup.answers = "[A] Price  [B] Quality of the Graphics  [C] Story  [D] Online Gameplay Capability"
			dialoguePopup.open()
		5:
			if answer == "B":
				correct_answers += 1
			dialogue_state = 6
			# Show dialogue popup
			dialoguePopup.dialogue = "5. Which of the following is not a gratification a player seeks in a game?"
			dialoguePopup.answers = "[A] Recognition  [B] Socialization  [C] Gustation  [D] Challenge"
			dialoguePopup.open()
		6:
			if answer == "C":
				correct_answers += 1
			dialogue_state = 7
			# Show dialogue popup
			dialoguePopup.dialogue = "6. What is the most popular game in the world?"
			dialoguePopup.answers = "[A] Call of Duty  [B] League of Legends  [C] Among Us  [D] Counter Strike"
			dialoguePopup.open()
		7:
			if answer == "C":
				correct_answers += 1
			# Update dialogue tree state
			dialogue_state = 8
			# Show dialogue popup
			dialoguePopup.dialogue = "7. How many Game Engine Layers are there?"
			dialoguePopup.answers = "[A] 14  [B] 7  [C] 21  [D] 3"
			dialoguePopup.open()
		8:
			if answer == "A":
				correct_answers += 1
			dialogue_state = 9
			# Show dialogue popup
			dialoguePopup.dialogue = "8. What is the most sold game in the world up until now?"
			dialoguePopup.answers = "[A] Wii Sports  [B] Tetris  [C] Minecraft [D] Grand Theft Auto V"
			dialoguePopup.open()
		9:
			if answer == "C":
				correct_answers += 1
			dialogue_state = 10
			# Show dialogue popup
			dialoguePopup.dialogue = "9. Which of these is not part of the staff of DJCO? (if you don't know this one you're in real trouble)"
			dialoguePopup.answers = "[A] Rui Rodrigues  [B] Augusto Sousa  [C] Rodrigo Assaf  [D] Eduardo Fonseca"
			dialoguePopup.open()
		10:
			if answer == "B":
				correct_answers += 1
			dialogue_state = 11
			# Show dialogue popup
			dialoguePopup.dialogue = "10. What is the best game genre?"
			dialoguePopup.answers = "[A] RPG  [B] RPG  [C] RPG  [D] All of the above"
			dialoguePopup.open()
		11:
			if answer == "D":
				correct_answers += 1
			dialogue_state = 12
			if correct_answers >= 5:
				dialoguePopup.dialogue = "Congratulations! You've passed with a final grade of " + str(correct_answers*2) + "/20."
				dialoguePopup.answers = "Cool cool cool!"
			else:
				dialoguePopup.dialogue = "I'm sorry, Manel! You've failed with a final grade of " + str(correct_answers*2) + "/20."
				dialoguePopup.answers = "Oh noooo."
			dialoguePopup.open()
		12:
			# Update dialogue tree state
			dialogue_state = 0
			# Close dialogue popup
			dialoguePopup.close()
