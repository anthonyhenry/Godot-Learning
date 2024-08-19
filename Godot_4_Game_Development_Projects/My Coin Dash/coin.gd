extends Area2D

var animationInProgress = false

func _ready():
	# Have each animation start at a random time 1-8 seconds after spawn
	$Timer.start(randi_range(1, 8))

func _process(delta):
	pass

# Play animation on timeout
func _on_timer_timeout():
	$AnimatedSprite2D.play()
	animationInProgress = true

# Reset timer when animation has finished
func _on_animated_sprite_2d_animation_finished():
	$Timer.start(randi_range(1, 8))
	animationInProgress = false

func pause():
	# Pause animation if playing
	if animationInProgress:
		$AnimatedSprite2D.pause()
	# Pause timer otherwise
	else:
		$Timer.paused = true

func unpause():
	# Resume animation if it was started
	if animationInProgress:
		$AnimatedSprite2D.play()
	# Unpause timer otherwise
	else:
		$Timer.paused = false

func pickup():
	$Pickup.play()
	$CollisionShape2D.set_deferred("disabled", true)
	var coinTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	coinTween.tween_property(self, "scale", scale * 3, 0.3)
	coinTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await coinTween.finished
	queue_free()

func despawn():
	var despawnTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	despawnTween.tween_property(self, "scale", scale / 3, 0.3)
	despawnTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await despawnTween.finished
	queue_free()
