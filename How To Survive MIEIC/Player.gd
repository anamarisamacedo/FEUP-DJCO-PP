extends KinematicBody2D

# Variables
var life = 100
var maxXP = 100
var minXP = 0
var moveSpeed = 250 
var interactDist = 70
signal player_stats_changed
var b210key = false
signal player_beers_changed
signal player_books_changed
 
var vel = Vector2()
var facingDir = Vector2()
var timer
var number_beers = 0
var number_books = 0
 
onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

var mainScene 
# Called when the node enters the scene tree for the first time.
func _ready():
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
		
	# Turn RayCast2D toward movement direction
	if facingDir != Vector2.ZERO:
		$RayCast2D.cast_to = facingDir.normalized() * 50
	
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
		var target = $RayCast2D.get_collider()
		if target != null and target.is_in_group("NPCs"):
			# Talk to NPC
			target.talk()
			return

func hit(damage):
	life -= damage
	emit_signal("player_stats_changed", self)
	if life <= minXP:
		game_lost()
	else:
		$AnimationPlayer.play("Hit")
			
func add_life(xp):
	life += xp
	life = min(life, maxXP)
	emit_signal("player_stats_changed", self)
	
func game_lost():
	set_process(false)
	GlobalVariables.game_lost()
		
func add_beer():
	number_beers += 1
	emit_signal("player_beers_changed", self)
	
func remove_beer():
	number_beers -= 1
	emit_signal("player_beers_changed", self)
	
func add_book():
	number_books += 1
	emit_signal("player_books_changed", self)
	
func remove_book():
	number_books -= 1
	emit_signal("player_books_changed", self)
