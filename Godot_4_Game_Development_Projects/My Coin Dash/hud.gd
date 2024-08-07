extends CanvasLayer

signal play_game

func update_timer(time):
	$Text/Time.text = str(time)

func update_score(score):
	$Text/Score.text = str(score)
	
func showText(messageText):
	$Buttons/StartButton.show()
	$Buttons/ExitButton.show()
	$CenterText.text = messageText
	$CenterText.show()

func _on_start_button_pressed():
	$Buttons/StartButton.hide()
	$Buttons/ExitButton.hide()
	$CenterText.hide()
	emit_signal("play_game")

# Quit game if exit button is pressed
func _on_exit_button_pressed():
	get_tree().quit()
