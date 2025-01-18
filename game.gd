extends Node2D

var rng = RandomNumberGenerator.new()
signal playerDeath
var powerupCount = 0


func _ready():
	var startingDifficulty = 5
	for i in range(0,startingDifficulty):
		spawn_mob()
	spawn_powerup("Invince")
	



func spawn_mob():
	var newMob = preload("res://enemy.tscn").instantiate()
	%MobSpawn.progress_ratio = randf()
	newMob.global_position = %MobSpawn.global_position
	add_child(newMob)
	
func spawn_powerup(type: String):
	var newPowerup = preload("res://power_up.tscn").instantiate()
	newPowerup.type = "Invince"
	%MobSpawn.progress_ratio = randf()
	newPowerup.global_position = %MobSpawn.global_position
	add_to_group("pickups")
	add_child(newPowerup)
	


func spawn_tree( basePos, count):
	for i in count:
		var newTree = preload("res://tree.tscn").instantiate()
		var offset = rng.randf_range(0.3,0.7) * 40
		var sizeMult = rng.randf_range(0.8,3)
		if i != 0:
			%MobSpawn.progress_ratio = (basePos + offset*sizeMult)
			newTree.global_position = %MobSpawn.global_position
			newTree.scale *= sizeMult
		else:
			%MobSpawn.progress_ratio = (basePos)
			newTree.global_position = %MobSpawn.global_position
			newTree.scale *= sizeMult
		add_child(newTree)
	

func _on_timer_timeout() -> void:
	spawn_mob()
	var treeCount = rng.randi_range(0,4)
	%MobSpawn.progress_ratio = randf()
	spawn_tree(%MobSpawn.progress_ratio,treeCount)
	powerupCount +=1
	if powerupCount >= 20:
		spawn_powerup("Invince")
		powerupCount = 0
	


func _on_player_health_depleted() -> void:
	playerDeath.emit()	


func _on_stopwatch_timeout() -> void:
	%TimeCount.text = str(int(%TimeCount.text)+1)
	
	
