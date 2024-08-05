extends Area2D

signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

func start():
	# Begin calling the process function every frame
	set_process(true)
	# Set starting position
	position = screensize / 2
	# Set initial animation as idle
	$AnimatedSprite2D.animation = "idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input.get_vector returns a direction vector based on keyboard input
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Returns (-1, 0), (1, 0), (0, -1), or (0, 1) 
	#print_debug(velocity)
	# Update the player's position using the velocity vector above
	position += velocity * speed * delta # Multiply by delta to keep a consistent speed independent of frame rate
	# Use Clamp to set min and max values for the player's position
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# Set run animation if velocity is not 0
	#print_debug(velocity.length()) #.length() returns the length of a vector
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	# Flip the animation if the vector is in a negative x direction
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0 # flip_h is a boolean so we can use a boolean statement to set it

func die():
	# Set animation to hurt
	$AnimatedSprite2D.animation = "hurt"
	# Stop calling the process function every frame
	set_process(false)


# This function runs whenever another area node overlaps with this node.
	# The overlapping area gets passed in as the area parameter
func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
