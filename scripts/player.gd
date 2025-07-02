extends CharacterBody2D


@export var speed = 300
@export var gravity = 30
@export var jump_force = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("jump"): #&& is_on_floor(): #disables multiple jumps on the air
		velocity.y = -jump_force		
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	#velocity.x = speed * horizontal_direction
	velocity.x += speed * horizontal_direction #this 2 lines will add friction when moving
	velocity.x *= 0.7
	move_and_slide()
	
	pass
