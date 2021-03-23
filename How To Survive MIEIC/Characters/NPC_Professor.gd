extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite
enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status
var dialogue_state = 0
var bookFound = false
var dialoguePopup
var player
var professorJoao
var challenges
var preserverance = 0

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
	challenges = get_tree().root.get_node("/root/Global/CanvasLayer/Control/Challenges")
	quest_status = GlobalVariables.quest_status_professor1
	
func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Professor Carlos"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hi student! I know you from DJCO classes! Do you need help? "
					dialoguePopup.answers = "[A] Yes, teacher! I would like to do a project. [B] No, I'm just walking around. "
					dialoguePopup.open()
				1:
					
					match answer:
						"A":
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "Oh, I see... I can raise it if you delivery me 1 project. Go to room B010, maybe you'll find something to help you."
							dialoguePopup.answers = "[A] Ok, thank you."
							dialoguePopup.open()
					match answer:
						"B":
							dialogue_state = 3
							dialoguePopup.dialogue = "Ok! See you in classes."
							dialoguePopup.answers = "[A] Bye"
							dialoguePopup.open()
				3:
					dialogue_state = 0
					dialoguePopup.close()				
				4:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_professor1 = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
					player.talkedWithCarlos = true
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					if player.project1Found == true:
						# Update dialogue tree state
						dialogue_state = 1
						# Show dialogue popup
						dialoguePopup.dialogue = "Hey, student! Do you have the project?"
						dialoguePopup.answers = "[A] Yes, I have it here!"
						dialoguePopup.open()
					elif player.b010key == false: 
						# Update dialogue tree state
						dialogue_state = 1
						# Show dialogue popup
						dialoguePopup.dialogue = "Hey, student! Do you have the project?"
						dialoguePopup.answers = "[B] Not yet. I can't find the keys to the room."
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Hey, student! Do you have the project?"
						dialoguePopup.answers = "[B] Not yet."
						dialoguePopup.open()
				1: 
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 3
							dialoguePopup.dialogue = "Good! I'm going to raise your grade!."
							dialoguePopup.answers = "[A] Thank you, bye!"
							dialoguePopup.open()
					match answer:
						"B":
							# Update dialogue tree state
							dialogue_state = 4
							dialoguePopup.dialogue = "Check in the library, maybe you'll have luck."
							dialoguePopup.answers = "[A] Ok, thank you!"
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 4
					dialoguePopup.dialogue = "Find me when you have it."
					dialoguePopup.answers = "[A] Ok, thank you!"
					dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					GlobalVariables.quest_status_professor1 = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					player.completed_project()
					player.delivered_Carlos_project = true
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
				4:
					# Update dialogue tree state
					dialogue_state = 0
					dialoguePopup.close()
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hey, student. Do you need help?"
					dialoguePopup.answers = "[B] No, thank you."
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
		
	animates_professor(direction)


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

func animates_professor(direction_var: Vector2):
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
		
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
