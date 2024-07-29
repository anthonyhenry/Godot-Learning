extends Area2D

var screensize = Vector2.ZERO

# This function gets called by the player script when the player overlaps with a coin
func pickup():
	# queue_free() is Godot's methos for removing nodes
	queue_free()
