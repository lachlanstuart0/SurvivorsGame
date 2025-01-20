extends CharacterBody2D


#@onready var enemy = get_node("/root/MasterScene/Game/Enemy")


var health = 100.0
signal healthDepleted
var playerState
var musicPosition = 0
var musicFaster = false
var exp = 0
var expMult = 5
@onready var killCount = get_node("/root/MasterScene/Game/InGameUI/ColorRect/KillCount")
var lastKillCount = 0
signal levelUp
var speedMult = 1
var gunCount = 1
var gunSpeed = 1.0

func _ready():
	pass
	#var enemy = get_node("res://enemy.tscn")
	#enemy.enemyDeath.connect(_on_enemyDeath)

func _physics_process(delta: float):
	#Deal with player input
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Deal with player movement and animation
	velocity = direction * 600 * speedMult
	move_and_slide()
	if velocity != Vector2(0,0):
		get_node("HappyBoo").play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	#Deal with Item Pickup
	var itemOverlap = %PickupBox.get_overlapping_bodies()
	if itemOverlap.size() > 0:
		for item in itemOverlap:
			#print(item)
			if item.type == "Invince":
				%InvinceTimer.start()
				health = 100
				%HealthBar.value = health
				%Invince.visible = true
				musicPosition = %MainMusic.get_playback_position()
				if !musicFaster:
					%MainMusic.pitch_scale = %MainMusic.pitch_scale * 2
					for i in range(1,gunCount+1):
						if i == 1:
							var gunTimer = get_node("gun/Timer")
							gunTimer.stop()
							gunTimer.start(0)
						else:
							var gunTimer = get_node("gun" + str(i) + "/Timer")
							gunTimer.stop()
							gunTimer.start(0)
					musicFaster = true
				#%MainMusic.stop()
				#%StarSound.play(0)
			
			item.queue_free()
	
	#Deal with EXP
	if int(killCount.text) - lastKillCount > 0:
		var diff = int(killCount.text) - lastKillCount
		lastKillCount = int(killCount.text)
		for i in range(0,diff):
			exp += 5* expMult
		%XPBar.value = exp
		if exp >= 100:
			exp = exp - 100
			level_up()
			%XPBar.value = exp
			expMult *= .5
			
	
	
	#skips damage step if invincible
	if %Invince.visible == true:
		return
	
	#Deal with Damage and Health
	const DAMAGERATE = 100.0
	var overlap = %Hitbox.get_overlapping_bodies()
	if overlap.size()>0:
		for body in overlap:
			health -= DAMAGERATE * delta
			%HealthBar.value = health
			if health < 0.0:
				healthDepleted.emit()
	

func level_up():
	health = 100
	%HealthBar.value = health
	levelUp.emit()
	pass

#End Invince
func _on_invince_timer_timeout() -> void:
	%Invince.visible = false
	#%MainMusic.pitch_scale = %MainMusic.pitch_scale / 2
	#%MainMusic.play(musicPosition)
	


func _on_speed_up_pressed() -> void:
	speedMult += 0.5



func _on_shoot_speed_up_pressed() -> void:
	gunSpeed /= 2
	for i in range(1,gunCount+1):
		if i == 1:
			var gunTimer = get_node("gun/Timer")
			gunTimer.wait_time = gunSpeed
		else:
			var gunTimer = get_node("gun" + str(i) + "/Timer")
			gunTimer.wait_time = gunSpeed
	
	#for i in range(1,gunCount+1):
		#var gunTimer = get_node("gun" + str(i) + "/Timer")
		#gunTimer.wait_time /= 2
	
	#var gunTimer = get_node("Gun/Timer")
	#gunTimer.wait_time /= 2


func _on_new_weapon_pressed() -> void:
	var newGun = preload("res://gun.tscn").instantiate()
	gunCount += 1
	newGun.name = "gun" + str(gunCount)
	add_child(newGun)
	var pistol = newGun.get_child(1).get_child(0)
	var gunTimer = get_node("gun" + str(gunCount) + "/Timer")
	gunTimer.wait_time = gunSpeed
	var bulletSpawn = pistol.get_child(0)
	if gunCount % 2 == 0:
		pistol.flip_h = true
		pistol.position += Vector2(-120,30*((gunCount-2)/2))
	else:
		pistol.position += Vector2(0,30*((gunCount-1)/2))
	pass # Replace with function body.
