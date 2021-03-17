extends ColorRect

func _on_Player_player_stats_changed(var player):
	$Bar.rect_size.x = 170 * player.life / 100.0
