extends Area2D

var direction = Vector2.ZERO
var speed = 350

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Set direction and animation based on input
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
		$AnimatedSprite2D.animation = "run"
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
		$AnimatedSprite2D.animation = "run"
	else:
		direction = Vector2.ZERO
		$AnimatedSprite2D.animation = "idle"
	
	# Set position
	position += direction * speed * delta
