extends CharacterBody2D


@export var speed = 100
@export var gravity = 45
@export var jump_force = 300

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 600:
			velocity.y = 600
			
	if Input.is_action_just_pressed("jump"): #&& is_on_floor(): #disables multiple jumps on the air
		velocity.y = -jump_force		
	
	
	#horizontal movement
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	#velocity.x = speed * horizontal_direction
	velocity.x += speed * horizontal_direction #this 2 lines will add friction when moving
	velocity.x *= 0.7
	
	
	#flip horizontal
	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	
	move_and_slide()
	
	update_animation(horizontal_direction)
	
	pass
	
func update_animation(horizontal_direction)	:
	
	if is_on_floor():
		if horizontal_direction == 0:
			animationPlayer.play("idle")
		else:
			animationPlayer.play("run")
	else:
		if velocity.y <= 0:
			animationPlayer.play("jump")
		elif velocity.y > 0:
			animationPlayer.play("fall")	
		
	pass
