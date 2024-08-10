extends Node

var timeRemaining = 30
var score = 0
var gamePaused = true
var gameStarted = false
var screensize = Vector2.ZERO
@export var playerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.update_timer(timeRemaining)
	$HUD.update_score(score)
	screensize = get_viewport().get_visible_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# HUD start button pressed
func _on_hud_play_game():
	# Check if game has already started
	if !gameStarted:
		# Spawn the player in the middle of the screen
		var spawnPlayer = playerScene.instantiate()
		add_child(spawnPlayer)
		spawnPlayer.screensize = screensize
		spawnPlayer.position = Vector2(screensize.x/2, screensize.y/2)

		# Set gameStarted to true
		gameStarted = true
	
	gamePaused = false
	$Player.unpause()
	$GameTimer.start()
	
func _input(event):
	# Escape key hit
	if event.is_action_pressed("pause"):
		# Pause game
		if !gamePaused:
			$HUD.show_text("Paused")
			gamePaused = true
			$Player.pause()
			$HUD.set_start_button_text("Resume")
		# Game already paused
		else:
			# Exit game if not already started
			if !gameStarted:
				get_tree().quit()
			# Run the same code from clicking start button
			else:
				$HUD.hud_unpause()

func _on_game_timer_timeout():
	if !gamePaused and timeRemaining > 0:
		timeRemaining -= 1
		$HUD.update_timer(timeRemaining)
