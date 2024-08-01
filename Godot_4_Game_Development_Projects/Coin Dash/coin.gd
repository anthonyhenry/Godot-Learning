extends Area2D

var screensize = Vector2.ZERO

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
