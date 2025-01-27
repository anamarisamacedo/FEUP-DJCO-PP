extends KinematicBody2D

# Node references
var player

# Random number generator
var rng = RandomNumberGenerator.new()

# Movement variables
export var speed = 60
var direction : Vector2
var last_direction = Vector2(0, 1)
var bounce_countdown = 0

# Animation variables
var other_animation_playing = false

# Attack variables
var attack_damage = 10
var attack_cooldown_time = 1500
var next_attack_time = 0
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	#current_scene = get_tree().get_current_scene().get_name()
	player = get_tree().root.get_node("/root/Global/Player")
	rng.randomize()

func _on_Timer_timeout():
	# Calculate the position of the player relative to the skeleton
	var player_relative_position = player.position - position
	
	if player_relative_position.length() <= 16:
		# If player is near, don't move but turn toward it
		direction = Vector2.ZERO
		last_direction = player_relative_position.normalized()
	elif player_relative_position.length() <= 200 and bounce_countdown == 0:
		# If player is within range, move toward it
		direction = player_relative_position.normalized()
	elif bounce_countdown == 0:
		# If player is too far, randomly decide whether to stand still or where to move
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update bounce countdown
	if bounce_countdown > 0:
		bounce_countdown = bounce_countdown - 1

func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		bounce_countdown = rng.randi_range(2, 5)
		
	if not other_animation_playing:
		animates_monster(direction)
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 50
	
	# Check if zombie can attack
	var now = OS.get_ticks_msec()
	if now >= next_attack_time:
		# What's the target?
		var target = $RayCast2D.get_collider()
		if target != null and target.name == "Player" and player.life > 0:
			# Play attack animation
			other_animation_playing = true
			var animation = get_animation_direction(last_direction) + "_attack"
			$AnimatedSprite.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time

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

func animates_monster(direction_var: Vector2):
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

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "die":
		get_tree().queue_delete(self)
	else:
		other_animation_playing = false

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation.ends_with("_attack") and $AnimatedSprite.frame == 1:
		var target = $RayCast2D.get_collider()
		if target != null and target.name == "Player" and player.life > 0:
			player.hit(attack_damage)

func die():
	$Timer.stop()
	direction = Vector2.ZERO
	set_process(false)
	other_animation_playing = true
	$AnimatedSprite.play("die")
