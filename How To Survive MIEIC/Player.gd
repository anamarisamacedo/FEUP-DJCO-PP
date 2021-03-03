extends KinematicBody2D

# Variables
var curSocial : int = 100
var social_decreasing = 0.01
var curStudy : int = 100
var study_decreasing = 0.01
var minXp : int = 0
var moveSpeed : int = 250 
var interactDist : int = 70
 
var vel = Vector2()
var facingDir = Vector2()
 
onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30
var attack_playing = false

# Health
var health = 100
var health_max = 100
var health_regeneration = 1
signal player_stats_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("player_stats_changed", self)

func _process(delta):
	# Decrease social status
	var new_social = max(curSocial - social_decreasing, minXp)
	if new_social != curSocial:
		curSocial = new_social
		emit_signal("player_stats_changed", self)

	# Decrease study status
	var new_study = max(curStudy - study_decreasing, minXp)
	if new_study != curStudy:
		curStudy = new_study
		emit_signal("player_stats_changed", self)
		
func _physics_process (delta):
	
	vel = Vector2()
	
	# inputs
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1, 0)
	
	# normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
	
	# move the player
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
	manage_animations()

func manage_animations ():
	
	if vel.x > 0:
		play_animation("MoveRight")
	elif vel.x < 0:
		play_animation("MoveLeft")
	elif vel.y < 0:
		play_animation("MoveUp")
	elif vel.y > 0:
		play_animation("MoveDown")
	elif facingDir.x == 1:
		play_animation("IdleRight")
	elif facingDir.x == -1:
		play_animation("IdleLeft")
	elif facingDir.y == -1:
		play_animation("IdleUp")
	elif facingDir.y == 1:
		play_animation("IdleDown")
		

func play_animation (anim_name):
	
	if anim.animation != anim_name:
		anim.play(anim_name)

func _input(event):
	if event.is_action_pressed("interact"):
		var target = move_and_collide(Vector2.ZERO)
		if target != null and target.collider.is_in_group("NPCs"):
			# Talk to NPC
			target.collider.talk()
			return
	
	if event.is_action_pressed("attack"):
	# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# Play attack animation
			attack_playing = true
			var animation = get_animation_direction(last_direction) + "_attack"
			$Sprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time

func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		pass
	else:
		$AnimationPlayer.play("Hit")
			
func add_social(xp):
	curSocial += xp
	emit_signal("player_stats_changed", self)
	if curSocial <= minXp:
		#GAME OVER
		$AnimationPlayer.play("Game Over")

func add_study(xp):
	curStudy += xp
	emit_signal("player_stats_changed", self)
	if curStudy <= minXp:
		#GAME OVER
		$AnimationPlayer.play("Game Over")
