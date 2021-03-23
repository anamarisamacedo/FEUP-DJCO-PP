extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

var dialogue_state = 0
var dialoguePopup
var player
var preserverance = 0

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 25
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/Global/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/Global/Player")

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Professor Augusto"
	
	match dialogue_state:
		0:
			if player.did_exam && !player.pass_exam:
				dialoguePopup.dialogue = "Hey, student! I hear you failed the exam."
				dialoguePopup.answers = "[A] Is there anything I can do? [B] Is all your fault!"
				dialogue_state = 2
			else:
				dialoguePopup.dialogue = "Hey, student! Don't forget to do your final exam in Room B021. Good luck!"
				dialoguePopup.answers = "[A] Thank you. Bye."
				dialogue_state = 1
			dialoguePopup.open()
		1:
			dialogue_state = 0
			dialoguePopup.close()
		2:
			if answer == "A":
				dialogue_state = 3
				dialoguePopup.dialogue = "I don't know, student. What are you willing to do?"
				dialoguePopup.answers = "[A] Anything, professor. [B] Well, I have my moral standarts professor..."
				dialoguePopup.open()
			else:
				dialogue_state = 1
				dialoguePopup.dialogue = "Well, I can't say I'm sorry you failed. With that attittude of yours, it was predictable."
				dialoguePopup.answers = "[A] Bye."
				dialoguePopup.open()
		3:
			if answer == "B":
				dialogue_state = 4
				dialoguePopup.dialogue = "Very well, student. If you show me your dedication, I'll let you retake the exam. What is the best quality in a student?"
				dialoguePopup.answers = "[A] Perseverance [B] Inteligence [C] Initiative [D] Oral Communication"
				dialoguePopup.open()
			else:
				dialogue_state = 1
				dialoguePopup.dialogue = "Where are your morals? There's nothing I can do for you, student. You're a lost soul. Goodbye"
				dialoguePopup.answers = "[A] Bye."
				dialoguePopup.open()
		4:
			if answer == "A":
				dialogue_state = 5
				dialoguePopup.dialogue = "And are preserverant, student?"
				dialoguePopup.answers = "[A] YES [B] Not really."
				dialoguePopup.open()
			elif answer == "B":
				dialogue_state = 1
				dialoguePopup.dialogue = "Wrong. Wrong. Wrong. Goodbye."
				dialoguePopup.answers = "[A] Bye."
				dialoguePopup.open()
			elif answer == "C":
				dialogue_state = 1
				dialoguePopup.dialogue = "Very well student. I will allow you to retake the exam. Bye."
				dialoguePopup.answers = "[A] Thank you!"
				player.retake_exam()
				dialoguePopup.open()
			else:
				dialogue_state = 1
				dialoguePopup.dialogue = "That's just stupid. Goodbye."
				dialoguePopup.answers = "[A] Bye."
				dialoguePopup.open()
		5:
			if answer == "A":
				dialogue_state = 5
				if preserverance >= 25:
					dialogue_state = 1
					dialoguePopup.dialogue = "You've showed me your presererance. I appreciate that. I will raise your grade to a 10/20. Congratulations, student!"
					dialoguePopup.answers = "[A] Thank you! Bye."
					player.raised_grade()
				else:
					dialoguePopup.dialogue = "And are preserverant, student?"
					dialoguePopup.answers = "[A] YES [B] Not really."
				dialoguePopup.open()
			else:
				dialogue_state = 1
				dialoguePopup.dialogue = "You don't have enough preserverance, student. Bye."
				dialoguePopup.answers = "[A] Bye."
				dialoguePopup.open()

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
