extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var dialogue_state = 0
var dialoguePopup
var player

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
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Professor Miguel"
	# Show the current dialogue
	match GlobalVariables.quest_status_professor4:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hi student! I'm glad I found you! I need you to do a group project. You need to find a partner and deliver me a project."
					dialoguePopup.answers = "[A] Okay, I'll do it! [B] I can't do that project right now."
					dialoguePopup.open()
				1:
					if answer == "A":
						player.talkedWithMiguel = true
						dialogue_state = 0
						GlobalVariables.quest_status_professor4 = QuestStatus.STARTED
						dialoguePopup.close()
					else:
						dialogue_state = 2
						dialoguePopup.dialogue = "I was not expecting that answer... You should think better about your answer and find me again."
						dialoguePopup.answers = "[A] Bye"
						dialoguePopup.open()
				2:
					dialogue_state = 0
					dialoguePopup.close()
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					if player.has_Miguel_Project == true:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hey, student! Do you have the project?"
						dialoguePopup.answers = "[A] Yes, here it is! [B] Not yet..."
						dialoguePopup.open()
					else:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hey, student! Do you have the project?"
						dialoguePopup.answers = "[B] Not yet..."
						dialoguePopup.open()
				1:
					if answer == "A" and player.has_Miguel_Project == true:
						dialogue_state = 2
						dialoguePopup.dialogue = "Very well, student! I'll raise your grade."
						dialoguePopup.answers = "[A] Thank you! Bye"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Find me when you have it."
						dialoguePopup.answers = "[A] Ok, professor."
						dialoguePopup.open()
				2:
					dialogue_state = 0
					GlobalVariables.quest_status_professor4 = QuestStatus.COMPLETED
					dialoguePopup.close()
					player.completed_project()
					player.delivered_Miguel_project = true
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
				
				3:
					dialogue_state = 0
					dialoguePopup.close()
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
	print("hello")
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1

