extends CanvasLayer

signal start_game

func update_score(value):
	# Change the Score text, this will be called by Main
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	# Change the Time text, this will be called by Main
	$MarginContainer/Time.text = str(value)

func show_message(text):
	# Display message
	$Message.text = text
	$Message.show()
	#Start timer
	$Timer.start()

func _on_timer_timeout():
	# Hide message when timer ends
	$Message.hide()

# Start button pressed signal
func _on_start_button_pressed():
	# Hide start button
	$StartButton.hide()
	# Hide message
	$Message.hide()
	start_game.emit()

func show_game_over():
	# Display Game Over message
	show_message("Game Over")
	# Wait 2 seconds
	await $Timer.timeout
	# Show start button
	$StartButton.show()
	# Change message text to Coin Dash
	$Message.text = "Coin Dash!"
	# Show message
	$Message.show()
