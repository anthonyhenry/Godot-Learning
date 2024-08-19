extends Area2D

func playerPickup():
	$Pickup.play()
	# Need to set_deferred "disabled" so that you can't keep colliding with the powerup during the tween
	$CollisionShape2D.set_deferred("disabled", true)
	var puPickupTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	puPickupTween.tween_property(self, "scale", scale * 3, 0.3)
	puPickupTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await puPickupTween.finished
	queue_free()

# Delete after timer
func _on_timer_timeout():
	despawn()

func despawn():
	var puDespawnTween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	puDespawnTween.tween_property(self, "scale", scale / 3, 0.3)
	puDespawnTween.tween_property(self, "modulate:a", 0.0, 0.3)
	await puDespawnTween.finished
	queue_free()
