extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var bookFound = false
var dialoguePopup
var player
var professorJoao

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 25
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

var xp_increase=30

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(answer = ""):
	# Set Fiona's animation to "talk"
	#$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Fiona
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Professor Carlos"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if bookFound:
						# Update dialogue tree state
						dialogue_state = 1
						# Show dialogue popup
						dialoguePopup.dialogue = "Hi student!  Do you need help?"
						dialoguePopup.answers = "[A] Yes, teacher! I would like some appointments to pass the DJCO exam. [B] No, I'm just walking around. "
						dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "Oh, I see... I can tell you where they are, but first I need to know that you pay attention to our classes. Wich of this is not a game engine?"
							dialoguePopup.answers = "[A] Godot [B] LibGDX [C] GameMaker [D] Ubity"
							dialoguePopup.open()
					match answer:
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Ok! See you in classes."
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
				
				4:
					match answer:
						"D":
							# Update dialogue tree state
							dialogue_state = 5
							# Show dialogue popup
							dialoguePopup.dialogue = "That is correct! Very well student, I see you have been paying attention! Well, I know that the appointments are in room B120, but I don't have the key. Maybe professor João has it. Find him."
							dialoguePopup.answers = "[A] Thank you, professor. Bye!"
							dialoguePopup.open()
							player.talkedWithCarlos = true
						"A" or "B" or "C":
							# Update dialogue tree state
							dialogue_state = 6
							# Show dialogue popup
							dialoguePopup.dialogue = "That is not the answer... You need to pay more attention. Find me when you know the answer."
							dialoguePopup.answers = "[A] Ok, professor."
							dialoguePopup.open()
				5:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					player.add_study(10)
				6: 
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Do you already know the answer, student?"
					dialoguePopup.answers = "[A] Yes [B] Not yet..."
					dialoguePopup.open()
				1:
					match answer:
						"A":
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Wich of this is not a game engine?"
							dialoguePopup.answers = "[A] Godot [B] LibGDX [C] GameMaker [D] Ubity"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Find me when you know it."
							dialoguePopup.answers = "[A] Ok, professor."
							dialoguePopup.open()
				2:
					match answer:
						"D":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "That is correct! Very well student, I see you have studied! I know that the appointments are in room B120, but I don't have the key. Maybe professor João has it. Find him."
							dialoguePopup.answers = "[A] Thank you, professor. Bye!"
							dialoguePopup.open()
						"A" or "B" or "C":
							# Update dialogue tree state
							dialogue_state = 5
							# Show dialogue popup
							dialoguePopup.dialogue = "That is not the answer... Find me when you know it."
							dialoguePopup.answers = "[A] Ok, professor."
							dialoguePopup.open()
					
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close
				4:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					player.add_study(10)
				5: 
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
					dialoguePopup.dialogue = "Hey, student! Did you find the appointments?"
					dialoguePopup.answers = "[A] Yes, thank you! [B] Not yet"
					dialoguePopup.open()
				1: 
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							dialoguePopup.dialogue = "Good! See you in classes."
							dialoguePopup.answers = "[A] Ok, bye!"
							dialoguePopup.open()
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							dialoguePopup.dialogue = "Check in the library. I think he's there."
							dialoguePopup.answers = "[A] Ok, thank you!"
							dialoguePopup.open()
				2:
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
		
	animates_professor(direction)


func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func animates_professor(direction: Vector2):
	if direction != Vector2.ZERO:
		last_direction = direction
		
		# Choose walk animation based on movement direction
		var animation = get_animation_direction(last_direction) + "_walk"
		
		# Play the walk animation
		$AnimatedSprite.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play(animation)

func _on_Timer_timeout():
	var random_number = rng.randf()
	if random_number < 0.01:
		direction = Vector2.ZERO
	elif random_number < 0.1:
		direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
