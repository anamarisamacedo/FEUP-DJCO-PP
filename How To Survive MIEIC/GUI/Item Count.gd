extends ColorRect

var current_scene

func _on_Player_player_beers_changed(var player):
	if player.number_beers < 10:
		$no_beers.text = "0" + str(player.number_beers)
	else:
		$no_beers.text = str(player.number_beers)


func _on_Player_player_books_changed(var player):
	if player.number_books < 10:
		$no_books.text = "0" + str(player.number_books)
	else:
		$no_books.text = str(player.number_books)
