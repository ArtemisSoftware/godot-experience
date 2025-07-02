extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	
	velocity.x = 300 * horizontal_direction
	move_and_slide()
	
	pass
