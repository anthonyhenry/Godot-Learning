extends Area2D

var velocity = Vector2.ZERO
var speed = 350
var screensize = Vector2.ZERO
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size

func pause():
	$AnimatedSprite2D.pause()
	paused = true

func unpause():
	$AnimatedSprite2D.play()
	paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !paused:
		# Set velocity and animation based on input
		if Input.is_action_pressed("ui_right"):
			velocity = Vector2(1, 0)
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			velocity = Vector2(-1, 0)
			$AnimatedSprite2D.animation = "run"
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("ui_up"):
			velocity = Vector2(0, -1)
			$AnimatedSprite2D.animation = "run"
		elif Input.is_action_pressed("ui_down"):
			velocity = Vector2(0, 1)
			$AnimatedSprite2D.animation = "run"
		else:
			# No velocity if no key is down
			velocity = Vector2.ZERO
			$AnimatedSprite2D.animation = "idle"
		
		# Set position
		position += velocity * speed * delta
	
	# Prevent player from going off screen
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)


func _on_area_entered(area):
	# Check for collision with coins
	if area.is_in_group("coins"):
		# Run the player touched coin function in Main
		if get_parent().get_name() == "Main":
			get_parent().player_touched_coin()
		area.queue_free()

func gameOver():
	paused = true
	$AnimatedSprite2D.animation = "hurt"
