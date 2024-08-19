extends Area2D

var animationInProgress = false

func playerPickup():
	$Pickup.play()
	# Need to set_deferred "disabled" so that you can't keep colliding with the powerup during the tween
	$CollisionShape2D.set_deferred("disabled", true)
	var puPickupTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	puPickupTween.tween_property(self, "scale", scale * 3, 0.3)
	puPickupTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await puPickupTween.finished
	queue_free()

# Delete when lifetime timer ends
func _on_timer_timeout():
	despawn()

func despawn():
	var puDespawnTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	puDespawnTween.tween_property(self, "scale", scale / 3, 0.3)
	puDespawnTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await puDespawnTween.finished
	queue_free()

func _on_start_animation_timer_timeout():
	animationInProgress = true
	#$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
	

func pause():
	# Pause animation if playing
	if animationInProgress:
		$AnimatedSprite2D.pause()
	# Pause animation start timer otherwise
	else:
		$StartAnimationTimer.paused = true
	# pause lifetime timer
	$LifetimeTimer.paused = true

func unpause():
	# Resume animation if it was started
	if animationInProgress:
		$AnimatedSprite2D.play()
	# Unpause timer otherwise
	else:
		$StartAnimationTimer.paused = false
	$LifetimeTimer.paused = false


func _on_animated_sprite_2d_animation_finished():
	animationInProgress = false
