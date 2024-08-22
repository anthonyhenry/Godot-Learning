extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable collision 
	$CollisionShape2D.disabled = true
	# Set invisible
	$Sprite2D.visible = false

func showCactus():
	# Enable collision 
	$CollisionShape2D.disabled = false
	# Set visible
	$Sprite2D.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
