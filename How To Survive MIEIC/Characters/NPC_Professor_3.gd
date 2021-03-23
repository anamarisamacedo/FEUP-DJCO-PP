extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var dialogue_state = 0
var dialoguePopup
var player
var library2
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
	library2 = get_tree().root.get_node("/root/Library2")
	
func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Professor João"
	
	# Show the current dialogue
	match GlobalVariables.quest_status_professor3:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if player.talkedWithCarlos:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hi student!  Do you need help?"
						dialoguePopup.answers = "[A] Yes! I need to enter on B010 and the professor has the keys. [B] Not really. "
						dialoguePopup.open()
					else:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hi student!  Do you need help?"
						dialoguePopup.answers = "[B] No, I'm just walking around."
						dialoguePopup.open()
				1:
					if answer == "A" and player.talkedWithCarlos:
						dialogue_state = 4
						dialoguePopup.dialogue = "Yes, I have the keys! But first I need you know that you have been paying attention to my classes. Wich of this is not a game engine?"
						dialoguePopup.answers = "[A] Godot [B] LibGDX [C] GameMaker [D] Ubity"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Ok! See you in classes."
						dialoguePopup.answers = "[A] Bye"
						dialoguePopup.open()
				3:
					dialogue_state = 0
					dialoguePopup.close()
				4:
					if answer == "D":
						dialogue_state = 5
						dialoguePopup.dialogue = "That is correct! Very well student, I see you are telling the truth! Here are the keys."
						dialoguePopup.answers = "[A] Thank you, professor. Bye!"
						dialoguePopup.open()
					else:
						dialogue_state = 6
						dialoguePopup.dialogue = "That is not the answer... You need to pay more attention. Find me when you know the answer."
						dialoguePopup.answers = "[A] Ok, professor."
						dialoguePopup.open()
				5:
					dialogue_state = 0
					GlobalVariables.quest_status_professor3 = QuestStatus.COMPLETED
					dialoguePopup.close()
					yield(get_tree().create_timer(0.5), "timeout") 
					library2.key_found()
					player.b010key = true
				6: 
					dialogue_state = 0
					GlobalVariables.quest_status_professor3 = QuestStatus.STARTED
					dialoguePopup.close()
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Do you already know the answer, student?"
					dialoguePopup.answers = "[A] Yes [B] Not yet..."
					dialoguePopup.open()
				1:
					if answer == "A":
						dialogue_state = 2
						dialoguePopup.dialogue = "Wich of this is not a game engine?"
						dialoguePopup.answers = "[A] Godot [B] LibGDX [C] GameMaker [D] Ubity"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Find me when you know it."
						dialoguePopup.answers = "[A] Ok, professor."
						dialoguePopup.open()
				2:
					if answer == "D":
						dialogue_state = 4
						dialoguePopup.dialogue = "That is correct! Very well student, I see you have studied! Here are the keys."
						dialoguePopup.answers = "[A] Thank you, professor. Bye!"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "That is not the answer... Find me when you know it."
						dialoguePopup.answers = "[A] Ok, professor."
						dialoguePopup.open()
				3:
					dialogue_state = 0
					dialoguePopup.close()
				4:
					dialogue_state = 0
					GlobalVariables.quest_status_professor3 = QuestStatus.COMPLETED
					dialoguePopup.close()
					# Key found
					library2.key_found()
					player.b010key = true
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hey, student! Do you need any help?"
					dialoguePopup.answers = "[A] No, thank you!"
					dialoguePopup.open()
				1:
					dialogue_state = 0
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
	rng.randomize()
	var random_number = rng.randf()
	if random_number < 0.01:
		direction = Vector2.ZERO
	elif random_number < 0.1:
		direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1
