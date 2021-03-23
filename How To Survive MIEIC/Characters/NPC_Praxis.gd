extends KinematicBody2D

# Variables
var moveSpeed : int = 250
onready var anim = $AnimatedSprite

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
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
	dialoguePopup.npc_name = "Stephen Hawking"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if alreadyTalked == false:
						player.talked_to_student()
						alreadyTalked = true
					if player.given_beers > 5:
						dialogue_state = 1
						quest_status = QuestStatus.COMPLETED
						player.secret_pass_exam()
						dialoguePopup.dialogue = "Hey! I hear you've been giving beers around. You're cool bro! Here's a little secret as a thank you: if you want to pass the final exam, just go with option C and the 10 is garanteed."
						dialoguePopup.answers = "[A] Thank you bro, you're really cool!"
						dialoguePopup.open()
					elif player.number_beers > 0:
						dialogue_state = 4
						dialoguePopup.dialogue = "Hey! Do you want to get me a beer?"
						dialoguePopup.answers = "[A] Yes, here it is!  [B] Not really"
						dialoguePopup.open()
					else:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hey! Do you want to get me a beer?"
						dialoguePopup.answers = "[A] Ok  [B] Not really"
						dialoguePopup.open()
				1:
					if answer == "A":
						dialogue_state = 2
						dialoguePopup.dialogue = "Cool. Try to find it and then bring it to me."
						dialoguePopup.answers = "[A] Ok"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Ok. If you change your mind, let me know."
						dialoguePopup.answers = "[A] Ok, bye"
						dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					dialoguePopup.close()
				3:
					dialogue_state = 0
					dialoguePopup.close()
				4:
					dialogue_state = 5
					player.remove_beer()
					dialoguePopup.dialogue = "Damn, you're the best, I'm going to tell my friends about you."
					dialoguePopup.answers = "[A] Thank you!"
					dialoguePopup.open()
				5:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					dialoguePopup.close()
					yield(get_tree().create_timer(0.5), "timeout")
					player.remove_beer()
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Did you find the beer?"
					if player.number_beers > 0:
						dialoguePopup.answers = "[A] Yes! [B] Not really"
					else:
						dialoguePopup.answers = "[A] Nope"
					dialoguePopup.open()
				1:
					if player.number_beers > 0 and answer == "A":
						dialogue_state = 2
						player.remove_beer()
						dialoguePopup.dialogue = "Damn, you're the best, I'm going to tell my friends about you."
						dialoguePopup.answers = "[A] Thank you"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "C'mon, you need to find it."
						dialoguePopup.answers = "[A] Ok."
						dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					dialoguePopup.close()
					yield(get_tree().create_timer(0.5), "timeout")
				3:
					dialogue_state = 0
					dialoguePopup.close()
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Thanks again, bro!"
					dialoguePopup.answers = "[A] Bye"
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
