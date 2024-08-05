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
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

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
	#Play LevelSound
	$LevelSound.play()
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
		#start powerup timer
		$PowerupTimer.start()

# Code that runs every time the GameTimer goes off (every second)
func _on_game_timer_timeout():
	# Decrement time_left
	time_left -= 1
	# Update timer in HUD
	$HUD.update_timer(time_left)
	# End game if no time left
	if(time_left <= 0):
		game_over()

# Player pickup coin signal
func _on_player_pickup(type):
	match type: # match is Godot's version of a switch statement
		"coin":
			# Play CoinSound
			$CoinSound.play()
			# Increment score
			score += 1
			# Update score in HUD
			$HUD.update_score(score)
		"powerup":
			# Play the powerup sound
			$PowerupSound.play()
			# Add more time
			time_left += 5
			$HUD.update_timer(time_left)

# Player hurt signal
func _on_player_hurt():
	game_over()

func game_over():
	#Play End Sound
	$EndSound.play();
	# Stop game
	playing = false
	$GameTimer.stop()
	# Remove all coins
	get_tree().call_group("coins", "queue_free")
	# Run game over function in HUD
	$HUD.show_game_over()
	# Kill the player
	$Player.die()

# HUD start_game signal
func _on_hud_start_game():
	new_game()

@export var powerup_scene : PackedScene
func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
