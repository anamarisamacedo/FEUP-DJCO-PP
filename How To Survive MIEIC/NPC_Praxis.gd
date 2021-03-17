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

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 25
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

var xp_increase = 30

func _ready():
	dialoguePopup = get_tree().root.get_node("/root/MainScene/Player/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("/root/MainScene/Player")

func talk(answer = ""):
	# Set Fiona's animation to "talk"
	#$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Fiona
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Omoletis Finus"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if player.number_beers > 0:
						# Update dialogue tree state
						dialogue_state = 4
						# Show dialogue popup
						dialoguePopup.dialogue = "Boas! Queres-me arranjar um fino?"
						dialoguePopup.answers = "[A] Sim, já o tenho!  [B] Não"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 1
						# Show dialogue popup
						dialoguePopup.dialogue = "Boas! Queres-me arranjar um fino?"
						dialoguePopup.answers = "[A] Pode ser  [B] Não me apetece"
						dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Fixe. Tenta encontrá-lo e depois traz-me."
							dialoguePopup.answers = "[A] Ok"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Tá-se, se mudares de ideias avisa"
							dialoguePopup.answers = "[A] Ok, xau"
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
				4:
					# Update dialogue tree state
					dialogue_state = 5
					# Show dialogue popup
					dialoguePopup.dialogue = "Eish, és o maior! Vou falar de ti aos meus amigos!"
					# Update Player XP
					player.add_social(xp_increase)
					player.remove_beer()
					dialoguePopup.answers = "[A] Obrigado"
					dialoguePopup.open()
				5:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					player.add_social(10)
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Encontraste o fino?"
					if player.number_beers > 0:
						dialoguePopup.answers = "[A] Sim! [B] Opá, não"
					else:
						dialoguePopup.answers = "[A] Nope"
					dialoguePopup.open()
				1:
					if player.number_beers > 0 and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Eish, és o maior! Vou falar de ti aos meus amigos!"
						# Update Player XP
						player.add_social(xp_increase)
						player.remove_beer()
						dialoguePopup.answers = "[A] Obrigado"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "Anda lá, encontra!"
						dialoguePopup.answers = "[A] Ok."
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Add XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					
					player.add_social(10)
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
					dialoguePopup.dialogue = "Obrigada mais uma vez, bro!"
					dialoguePopup.answers = "[A] Xau"
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

func animates_student(direction: Vector2):
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
