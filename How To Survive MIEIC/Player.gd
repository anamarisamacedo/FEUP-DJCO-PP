extends KinematicBody2D

# Variables
var curSocial = 100
var social_decreasing = 0.01
var maxSocial = 100
var curStudy = 100
var study_decreasing = 0.01
var maxStudy = 100
var minXp = 0
var moveSpeed = 250 
var interactDist = 70
signal player_stats_changed
 
var vel = Vector2()
var facingDir = Vector2()
 
onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

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

func hit(damage):
	curSocial -= damage
	emit_signal("player_stats_changed", self)
	if curSocial <= minXp:
		set_process(false)
		$AnimationPlayer.play("Game Over")
	else:
		$AnimationPlayer.play("Hit")
			
func add_social(xp):
	curSocial += xp
	curSocial = min(curSocial, maxSocial)
	emit_signal("player_stats_changed", self)
	if curSocial <= minXp:
		#GAME OVER
		$AnimationPlayer.play("Game Over")

func add_study(xp):
	curStudy += xp
	curStudy = min(curStudy, maxStudy)
	emit_signal("player_stats_changed", self)
	if curStudy <= minXp:
		#GAME OVER
		$AnimationPlayer.play("Game Over")
