extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

enum QuestStatus { NOT_STARTED, STARTED, PROJECT, COMPLETED }
var dialogue_state = 0
var beerFound = false
var dialoguePopup
var player
var alreadyTalked = false

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 25
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

var xp_increase = 30

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Bill Gates"
	
	# Show the current dialogue
	match GlobalVariables.quest_status_praxis_project:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if alreadyTalked == false:
						player.talked_to_student()
						alreadyTalked = true
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					print(player.talkedWithMiguel)
					if player.talkedWithMiguel == true:
						dialoguePopup.dialogue = "Hey! Do you need something?"
						dialoguePopup.answers = "[A] Do you wanna be my partner to the DJCO project? [B] Not really"
						dialoguePopup.open()
					else:
						dialoguePopup.dialogue = "Hey! Do you need something?"
						dialoguePopup.answers = "[B] Not really"
						dialoguePopup.open()
				1:
					match answer:
						"A":
							if player.number_beers > 0:
								# Update dialogue tree state
								dialogue_state = 3
								# Show dialogue popup
								dialoguePopup.dialogue = "Hmmm... I need to know that you are a cool bro, first. Can you get me 1 beer?"
								dialoguePopup.answers = "[A] Of course, here it is. [B] Meh, not worht it."
								dialoguePopup.open()
							else: 
								# Update dialogue tree state
								dialogue_state = 2
								# Show dialogue popup
								dialoguePopup.dialogue = "Hmmm... I need to know that you are a cool bro, first. Can you get me 1 beer?"
								dialoguePopup.answers = "[A] Yes, I'll find it [B] Not worht it."
								dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "Then get out."
							dialoguePopup.answers = "[Any Key] Bye."
							dialoguePopup.open()
				2:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 6
							# Show dialogue popup
							dialoguePopup.dialogue = "Cool, I'll be here."
							dialoguePopup.answers = "[Any Key] Ok!"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "Uau, not cool bro..."
							dialoguePopup.answers = "[Any Key] Bye."
							dialoguePopup.open()
					
				3:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 5
							# Show dialogue popup
							dialoguePopup.dialogue = "Cooool, I'll be your partner! Find me in B031, I'll be there to do the project."
							dialoguePopup.answers = "[A] Ok, see ya!"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "Uau, not cool bro..."
							dialoguePopup.answers = "[Any Key] Bye."
							dialoguePopup.open()
				4:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
				5:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_praxis_project = QuestStatus.PROJECT
					# Close dialogue popup
					dialoguePopup.close()
					player.remove_beer()
					get_tree().root.get_node("/root/Outside/NPC_Paxis_project").queue_free()
				6:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_praxis_project = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Did you find the beer?"
					if player.number_beers > 0:
						dialoguePopup.answers = "[A] Yes, here it is! [B] Not really"
					else:
						dialoguePopup.answers = "[A] Nope"
					dialoguePopup.open()
				1:
					if player.number_beers > 0 and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Cooool, I'll be your partner! Find me in B031, I'll be there to do the project."
						dialoguePopup.answers = "[A] Ok, see ya!"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "C'mon, you need to find it."
						dialoguePopup.answers = "[Any Key] Ok."
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_praxis_project = QuestStatus.PROJECT
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					player.remove_beer()
					get_tree().root.get_node("/root/Outside/NPC_Praxis2").queue_free()
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
		QuestStatus.PROJECT:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hey! While I was waiting for you, I finished the project. Can you deliver it to Professor Miguel?"
					dialoguePopup.answers = "[A] Wow, nice! Of course. [B] No"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Ok, bye!"
							dialoguePopup.answers = "[A] Bye!"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Well, I can't deliver it. Find me when you change your mind."
							dialoguePopup.answers = "[Any Key] Ok, bye."
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_praxis_project = QuestStatus.COMPLETED
					player.has_Miguel_Project = true
					# Close dialogue popup
					dialoguePopup.close()
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
					dialoguePopup.dialogue = "Thanks again, bro!"
					dialoguePopup.answers = "[A] Bye"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()

func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
		
	animates_student(direction)

func get_animation_direction(direction_var: Vector2):
	var norm_direction = direction_var.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_student(direction_var: Vector2):
	if direction_var != Vector2.ZERO:
		last_direction = direction_var
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play(animation)

func _on_Timer_timeout():
	rng.randomize()
	var random_number = rng.randf()
	if random_number < 0.01:
		direction = Vector2.ZERO
	elif random_number < 0.1:
		direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
