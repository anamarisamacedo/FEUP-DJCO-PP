extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

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
	dialoguePopup.npc_name = "Mark Zuckerberg"
	
	match dialogue_state:
		0:
			if alreadyTalked == false:
				player.talked_to_student()
				alreadyTalked = true
			# Update dialogue tree state
			dialogue_state = 1
			# Show dialogue popup
			dialoguePopup.dialogue = "Hey! Do you need some help?"
			dialoguePopup.answers = "[A] Yes.  [B] Not really"
			dialoguePopup.open()
		1:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.dialogue = "What do you want to know?"
					dialoguePopup.answers = "[A] How to I do my Final Exam? [B] How do I deliver projects?"
					dialoguePopup.open()
				"B":
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.dialogue = "Ok. If you need anything, I'll be around."
					dialoguePopup.answers = "[A] Ok, bye"
					dialoguePopup.open()
		2:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 4
					# Show dialogue popup
					dialoguePopup.dialogue = "You need to go to room B130 and find the exam paper."
					dialoguePopup.answers = "[A] Thank you. Bye [B] Thank you. I have another doubt."
					dialoguePopup.open()
				"B":
					# Update dialogue tree state
					dialogue_state = 4
					# Show dialogue popup
					dialoguePopup.dialogue = "You need to talk with the professors to get the assignments. Professor Carlos, Alberto, Augusto and Diogo usually have projects for the students."
					dialoguePopup.answers = "[A] Thank you. Bye [B] Thank you. I have another doubt."
					dialoguePopup.open()
		3:
			# Update dialogue tree state
			dialogue_state = 0
			# Close dialogue popup
			dialoguePopup.close()
		4:
			match answer:
				"B":
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.dialogue = "What do you want to know?"
					dialoguePopup.answers = "[A] How to I do my Final Exam? [B] How do I deliver projects?"
					dialoguePopup.open()
				"A":
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.dialogue = "Ok. If you need anything, I'll be around."
					dialoguePopup.answers = "[A] Ok, bye"
					dialoguePopup.open()

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
