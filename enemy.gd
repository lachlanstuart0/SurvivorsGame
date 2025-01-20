extends CharacterBody2D

const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
@onready var player = get_node("/root/MasterScene/Game/Player")
@onready var killCount = get_node("/root/MasterScene/Game/InGameUI/ColorRect/KillCount")
@onready var enemyCount = get_node("/root/MasterScene/Game/InGameUI/ColorRect3/EnemyCount")
var health = 4
signal enemyDeath

func _ready():
	%Slime.play_walk()

func _physics_process(delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 90
	move_and_slide()
	
func take_damage ():
	%Slime.play_hurt()
	health -= 1
	if health == 0:
		killCount.text = str(int(killCount.text)+1)
		enemyCount.text = str(int(enemyCount.text)-1)
		queue_free()
		#enemyDeath.emit()
		var smoke = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
	
	
