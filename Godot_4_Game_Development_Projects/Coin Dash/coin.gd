extends Area2D

var screensize = Vector2.ZERO

func _ready():
	# Have the animation start after 3-8 seconds
	$Timer.start(randf_range(3,8))

# This function gets called by the player script when the player overlaps with a coin
func pickup():
	# This is how you disable collision
	$CollisionShape2D.set_deferred("disablesd", true)
	# Create tween
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	# Wait until tween is finished to proceed
	await tw.finished
	# queue_free() is Godot's methos for removing nodes
	queue_free()


func _on_timer_timeout():
	# Play the animation starting from frame 0
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()


func _on_area_entered(area):
	# Check if the coin is on an obstacle
	if area.is_in_group("obstacles"):
		# Move the coin
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
