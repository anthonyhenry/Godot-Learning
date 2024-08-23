extends Node

const INITIAL_TIME_REMAINING = 30
const INITIAL_LEVEL = 1
const INITIAL_SCORE = 0
const INITIAL_COIN_COUNT = 0

var level = INITIAL_LEVEL
var timeRemaining = INITIAL_TIME_REMAINING
var score = INITIAL_SCORE
var coinCount = INITIAL_COIN_COUNT
var gamePaused = true
var gameStarted = false
var screensize = Vector2.ZERO

@export var playerScene : PackedScene
@export var coinScene : PackedScene
@export var powerupScene : PackedScene
@export var cactusScene : PackedScene

func _ready():
	$HUD.update_timer(timeRemaining)
	$HUD.update_score(score)
	screensize = get_viewport().get_visible_rect().size
	
func _process(delta):
	get_tree().get_nodes_in_group("obstacles")
	pass

# Game unpaused
func _on_hud_play_game():
	# Game hasn't started yet
	if !gameStarted:
		# Reset game variables
		level = INITIAL_LEVEL
		timeRemaining = INITIAL_TIME_REMAINING
		score = INITIAL_SCORE
		coinCount = INITIAL_COIN_COUNT
		# Reset HUD
		$HUD.update_timer(timeRemaining)
		$HUD.update_score(score)
		# Spawn the player in the middle of the screen
		var spawnPlayer = playerScene.instantiate()
		add_child(spawnPlayer)
		spawnPlayer.position = Vector2(screensize.x/2, screensize.y/2)
		# Spawn coins
		spawnCoins()
		# Start timer
		$GameTimer.start()
		# Set gameStarted to true
		gameStarted = true
	
	gamePaused = false
	$Player.unpause()
	$GameTimer.paused = false
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.unpause()
	if get_node_or_null("Powerup") != null:
		get_node("Powerup").unpause()
	$PowerupSpawnTimer.paused = false
	
func _input(event):
	# Escape key hit
	if event.is_action_pressed("pause"):
		# Pause game
		if !gamePaused:
			gamePaused = true
			# Pause timer
			$GameTimer.paused = true 
			# Show HUD
			$HUD.hideLevel()
			$HUD.show_text("Paused")
			$HUD.set_start_button_text("Resume")
			# Stop player animation and input
			$Player.pause()
			# Pause coins
			for coin in get_tree().get_nodes_in_group("coins"):
				coin.pause()
			# Pause powerup
			if get_node_or_null("Powerup") != null:
				get_node("Powerup").pause()
			$PowerupSpawnTimer.paused = true

		# Game already paused
		else:
			# Exit game if not already started
			if !gameStarted:
				get_tree().quit()
			# Run the same code from clicking start button
			else:
				# Unpause HUD
				$HUD.hud_unpause()

func _on_game_timer_timeout():
	if !gamePaused:
		timeRemaining -= 1
		$HUD.update_timer(timeRemaining)
		
	# Game over
	if timeRemaining == 0:
		# Play game over sfx
		$GameOverSFX.play()
		# Stop the timer from infinitely ticking
		$GameTimer.paused = true
		# Stop powerup from spawning
		$PowerupSpawnTimer.paused = true
		# Run player game over function (sets hurt animation)
		$Player.gameOver()
		# Show game over text
		$HUD.show_text("Game Over")
		
		# Start game over timer
		$GameOverTimer.start()
		gamePaused = true
		gameStarted = false
		
func spawnCoins():
	$HUD.showLevel("Level " + str(level))
	$LevelTextTimer.start()
	
	# Find out how many cacti to spawn
	var cactusCountPattern = [0, 1, 2, 3, 2, 1]
	var levelCactiCount = cactusCountPattern[(level - 1) % 6]
	# Find out how many cacti are already in the level
	var currentCactiCount = get_tree().get_nodes_in_group("obstacles")
	
	if currentCactiCount.size() != levelCactiCount:
		# Need to add cactus
		if levelCactiCount > currentCactiCount.size():
			var cactusPlaced = false
			# Spawn cactus
			var spawnCactus = cactusScene.instantiate()
			#add_child(spawnCactus)
			call_deferred("add_child", spawnCactus)
			
			while cactusPlaced == false:
				# Spawn cactus in a random position
				spawnCactus.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
				
				# Check if cactus is too close to the player
				var player = get_node_or_null("Player")
				if player != null:
					var distanceToPlayer = spawnCactus.position.distance_squared_to(player.position)
					# Loop again if too close
					if distanceToPlayer < 2600:
						continue
				
				# Check if cactus is too close to other cacti
				if currentCactiCount.size() > 0:
					var distanceToClosestCactus = null
					for cacti in currentCactiCount:
						var distanceToCactus = spawnCactus.position.distance_squared_to(cacti.position)
						if distanceToClosestCactus == null || distanceToCactus < distanceToClosestCactus:
							distanceToClosestCactus = distanceToCactus
					# Loop again if too close
					if distanceToClosestCactus < 2500:
						continue
				
				cactusPlaced = true
				spawnCactus.call_deferred("showCactus")
		# Need to remove cactus
		else:
			get_tree().get_first_node_in_group("obstacles").queue_free()
	
	while coinCount < level + 4:
		var spawnCoin = coinScene.instantiate()
		#add_child(spawnCoin)
		call_deferred("add_child", spawnCoin)
		spawnCoin.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		coinCount += 1

func player_touched_coin(coin):
	coin.pickup()
	# Increment score
	score += 1
	$HUD.update_score(score)
	# Decrement coin count
	coinCount -= 1
	# Start new level if all coins have been collected
	if coinCount == 0:
		level += 1
		timeRemaining += 5
		$HUD.update_timer(timeRemaining)
		spawnCoins()


func _on_game_over_timer_timeout():
	# Set start button to say retry
	$HUD.set_start_button_text("Retry")
	# Delete player
	$Player.queue_free()
	# Despawn coins
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.despawn()
	# Despawn power-up
	if get_node_or_null("Powerup") != null:
		get_node("Powerup").despawn()

func _on_level_text_timer_timeout():
	$HUD.hideLevel()
	pass # Replace with function body.


func _on_powerup_spawn_timer_timeout():
	var powerupSpawn = powerupScene.instantiate()
	add_child(powerupSpawn)
	powerupSpawn.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
