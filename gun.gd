extends Area2D

var EnemiesInRange

func _physics_process(delta: float):
	EnemiesInRange = get_overlapping_bodies()
	if EnemiesInRange.size()>0:
		var targetEnemy = EnemiesInRange[0]
		look_at(targetEnemy.global_position)
		

func shoot():
	const BULLET = preload("res://Bullet.tscn")
	var newBullet = BULLET.instantiate()
	newBullet.global_position = %BulletSpawn.global_position
	newBullet.global_rotation = %BulletSpawn.global_rotation

	%BulletSpawn.add_child(newBullet)
	
	


func _on_timer_timeout() -> void:
	if EnemiesInRange.size()>0:
		shoot()
