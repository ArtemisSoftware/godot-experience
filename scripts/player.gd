extends CharacterBody2D


@export var speed = 70#100
@export var gravity = 45
@export var jump_force = 300

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast_1: RayCast2D = $CrouchRaycast_1
@onready var crouch_raycast_2: RayCast2D = $CrouchRaycast_2
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var jump_height_timer: Timer = $JumpHeightTimer


var is_crouching = false
var stuck_under_object = false
var can_cayote_jump = false
var jump_buffered = false

var standing_cshape = preload("res://assets/player/collisions/knight_standing_cshape.tres")
var crouching_cshape = preload("res://assets/player/collisions/knight_crouching_cshape.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if !is_on_floor() && (can_cayote_jump == false):
		velocity.y += gravity
		if velocity.y > 600:
			velocity.y = 600
			
	if Input.is_action_just_pressed("jump"):
		jump_height_timer.start()
		jump()
	
	#horizontal movement
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	#velocity.x = speed * horizontal_direction
	velocity.x += speed * horizontal_direction #this 2 lines will add friction when moving
	velocity.x *= 0.7
	
	
	#flip horizontal
	
	if horizontal_direction != 0:
		switch_direction(horizontal_direction)
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else: 
			if stuck_under_object != true:
				stuck_under_object = true
	
	
	if stuck_under_object && above_head_is_empty():
		stand()
		stuck_under_object = false
	
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	# Started to fall
	
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_cayote_jump = true
		coyote_timer.start()
	
	# Touched ground
	if !was_on_floor && is_on_floor():
		if jump_buffered:
			jump_buffered = false
			jump()
		
	update_animation(horizontal_direction)
	
	pass
	

func _on_coyote_timer_timeout() -> void:
	can_cayote_jump = false
	pass # Replace with function body.	
	
	
func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false
	pass # Replace with function body.	
	

func _on_jump_height_timer_timeout() -> void:
	if ! Input.is_action_pressed("jump"):
		if velocity.y < -100:
			velocity.y = -100
			print("Low jump")
	else:
		print("High jump")
		pass	
	
	
	pass # Replace with function body.
	
	
func switch_direction(horizontal_direction)	:
	sprite.flip_h = (horizontal_direction == -1)
	sprite.position.x = horizontal_direction * 4
	pass
	
func jump() -> void:
	if is_on_floor() || can_cayote_jump:
		velocity.y = -jump_force
		if can_cayote_jump:
			print("Cayote time")
			can_cayote_jump = false		
	else:
		if !jump_buffered:
			jump_buffered = true
			jump_buffer_timer.start()	
		
func update_animation(horizontal_direction)	:
	
	if is_on_floor():
		if horizontal_direction == 0 && is_crouching:
			animationPlayer.play("crouch")
		elif horizontal_direction == 0: 
			animationPlayer.play("idle")	
		elif horizontal_direction != 0 && is_crouching:	
			animationPlayer.play("crouch_walk")
		else:
			animationPlayer.play("run")
	else:
		if velocity.y <= 0:
			animationPlayer.play("jump")
		elif velocity.y > 0:
			animationPlayer.play("fall")	
		
	pass
	
func crouch():
	if is_crouching:
		return
	is_crouching = true	
	cshape.shape = crouching_cshape
	cshape.position.y = -12
	
func stand():
	is_crouching = false	
	cshape.shape = standing_cshape
	cshape.position.y = -17
	
func above_head_is_empty() -> bool:
	var result = !crouch_raycast_1.is_colliding() && !crouch_raycast_2.is_colliding()
	return result
