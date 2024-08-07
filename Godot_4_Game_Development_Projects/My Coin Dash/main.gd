extends Node

var timeRemaining = 10
var score = 0
var playingGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.update_timer(timeRemaining)
	$HUD.update_score(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hud_play_game():
	playingGame = true
	
func _input(event):
	if event.is_action_pressed("pause"):
		playingGame = !playingGame
		if playingGame == false:
			$HUD.showText("Paused")
		print_debug("pause")
