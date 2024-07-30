extends Node

@export var coin_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	# We can access the Player becuase it is a child of this node
	$Player.screensize = screensize
	$Player.hide() # hide() makes a node invisible
	#new_game() # Re-enable this for testing

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start() # Call the player's start function
	$Player.show()  # Show the player node
	$GameTimer.start() # Starting GameTimer will start counting down the remaining time in the game
	spawn_coins()
	
func spawn_coins():
	# Create as many coins as the current level + 4
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c) # Whenever you instantiate a new node, it must be added to the scene tree using add_chile()
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y)) # Give the coin a random position in the viewport

func _process(delta):
	# Check if all coins have been collected
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		# Increment level
		level += 1
		# Add more time
		time_left += 5
		# spawn coins for the next level
		spawn_coins()
