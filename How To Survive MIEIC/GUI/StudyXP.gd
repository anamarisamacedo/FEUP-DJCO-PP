extends ColorRect



func _on_Player_player_stats_changed(var player):
	print(player.curStudy)
	$Bar.rect_size.x = 95 * player.curStudy / 100
