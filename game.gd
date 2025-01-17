extends Node2D

var rng = RandomNumberGenerator.new()
signal playerDeath

func _ready():
	var startingDifficulty = 5
	for i in range(0,startingDifficulty):
		spawn_mob()
	



func spawn_mob():
	var newMob = preload("res://enemy.tscn").instantiate()
	%MobSpawn.progress_ratio = randf()
	newMob.global_position = %MobSpawn.global_position
	add_child(newMob)
	


func spawn_tree( basePos, count):
	for i in count:
		var newTree = preload("res://tree.tscn").instantiate()
		var offset = rng.randf_range(0.3,0.10) * 40
		if i != 0:
			%MobSpawn.progress_ratio = (basePos + offset)
			newTree.global_position = %MobSpawn.global_position
		else:
			%MobSpawn.progress_ratio = (basePos)
			newTree.global_position = %MobSpawn.global_position
		add_child(newTree)
	

func _on_timer_timeout() -> void:
	spawn_mob()
	var treeCount = rng.randi_range(0,4)
	%MobSpawn.progress_ratio = randf()
	spawn_tree(%MobSpawn.progress_ratio,treeCount)
	


func _on_player_health_depleted() -> void:
	playerDeath.emit()	


func _on_stopwatch_timeout() -> void:
	%TimeCount.text = str(int(%TimeCount.text)+1)
	
	
