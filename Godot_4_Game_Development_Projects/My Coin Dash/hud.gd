extends CanvasLayer

signal play_game

func update_timer(time):
	$Text/Time.text = str(time)

func update_score(score):
	$Text/Score.text = str(score)
	
func set_start_button_text(text):
	$Buttons/StartButton.show()
	$Buttons/ExitButton.show()
	$Buttons/StartButton.text = text
	
func show_text(messageText):
	$CenterText.text = messageText
	$CenterText.show()

func _on_start_button_pressed():
	hud_unpause()

# Quit game if exit button is pressed
func _on_exit_button_pressed():
	get_tree().quit()

func hud_unpause():
	$Buttons/StartButton.hide()
	$Buttons/ExitButton.hide()
	$CenterText.hide()
	emit_signal("play_game")


func _on_ready():
	set_start_button_text("Start")
