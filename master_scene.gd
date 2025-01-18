extends Node2D


func _ready() -> void:
	#pass
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()




func _on_game_player_death() -> void:
	#%Game.paused = true
	#get_node("%Game")
	#print(get_tree_string_pretty())
	get_tree().paused = true
	%GameOver.visible = true
	


func _on_start_pressed() -> void:
	#get_tree().paused = false
	%MainMenuLayer.visible = false
	#%MainMenuTitle.visible = false
	%CharSelect.visible = true
	
	#$Game/InGameUI.visible = true
	#get_tree().paused = false
	


func _on_quit_pressed() -> void:
	
	#print(get_tree_string_pretty())
	%Game.get_tree().quit()


func _on_select_gavin_pressed() -> void:
	
	$Game/InGameUI.visible = true
	%CharSelect.visible = false
	get_tree().paused = false
	


func _on_select_waldo_pressed() -> void:
	_on_select_gavin_pressed()
	pass # Replace with function body.


func _on_select_jr_pressed() -> void:
	_on_select_gavin_pressed()
	pass # Replace with function body.
