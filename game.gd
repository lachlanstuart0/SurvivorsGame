extends Node2D

var rng = RandomNumberGenerator.new()
signal playerDeath
var powerupCount = 0
var enemyLimit = 125
@onready var enemyCount = get_node("/root/MasterScene/Game/InGameUI/ColorRect3/EnemyCount")
var playerLevel = 1
@onready var levelCount = get_node("/root/MasterScene/Game/InGameUI/ColorRect4/LevelCount")


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
	enemyCount.text = str(int(enemyCount.text)+1)
	
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
	

#Timer for spawning Objects, enemies, "trees", powerups
func _on_timer_timeout() -> void:
	#Spawn mobs based on player level
	if int(enemyCount.text) < enemyLimit:
		spawn_mob()
		if playerLevel > 5:
			spawn_mob()
			if playerLevel > 10:
				spawn_mob()
				spawn_mob()
	#Spawn Trees
	var treeCount = rng.randi_range(0,2)
	%MobSpawn.progress_ratio = randf()
	if powerupCount % 2 == 0:
		spawn_tree(%MobSpawn.progress_ratio,treeCount)
	powerupCount +=1
	#Spawn powerups based on count up to 20
	if powerupCount >= 20:
		spawn_powerup("Invince")
		powerupCount = 0
	if powerupCount == 15:
		var kids = get_children()
		var enemiesInRange = get_node("sightRange").get_overlapping_bodies()
		for kid in kids:
			if kid.get_class() == "CharacterBody2D" and kid not in enemiesInRange:
				if kid.name != "Player":
					kid.queue_free()
					spawn_mob()
					
	
	


func _on_player_health_depleted() -> void:
	playerDeath.emit()	
func _on_stopwatch_timeout() -> void:
	%TimeCount.text = str(int(%TimeCount.text)+1)	
func _on_speed_up_pressed() -> void:
	%LevelUpScreen.visible = false
	get_tree().paused = false
func _on_shoot_speed_up_pressed() -> void:
	%LevelUpScreen.visible = false
	get_tree().paused = false
func _on_new_weapon_pressed() -> void:
	%LevelUpScreen.visible = false
	get_tree().paused = false
func _on_player_level_up() -> void:
	%LevelUpScreen.visible = true
	get_tree().paused = true
	playerLevel +=1
	levelCount.text = str(playerLevel)
	enemyLimit += 25
	if %Timer.wait_time > 0.05:
		%Timer.wait_time -= 0.05
	
