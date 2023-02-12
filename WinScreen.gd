extends ColorRect

func _on_Main_winner(color):
	visible = true
	
	if(color == 1):
		$WinLabel.text = "RED WON!\n\nPress \'R\' To Play Again"
	if(color == 2):
		$WinLabel.text = "YELLOW WON!\n\nPress \'R\' To Play Again"
