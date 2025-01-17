extends Node2D


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()




func _on_game_player_death() -> void:
	#%Game.paused = true
	#get_node("%Game")
	print(get_tree_string_pretty())
	get_tree().paused = true
	%GameOver.visible = true
	
