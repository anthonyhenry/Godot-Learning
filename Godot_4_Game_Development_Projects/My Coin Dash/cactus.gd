extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable collision 
	$CollisionShape2D.set_deferred("disabled", true)
	# Set invisible
	visible = false
	pass

func showCactus():
	# Enable collision 
	$CollisionShape2D.set_deferred("disabled", false)
	# Set visible
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
