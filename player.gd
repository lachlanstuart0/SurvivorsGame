extends CharacterBody2D

var health = 100.0
signal healthDepleted

func _physics_process(delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	if velocity != Vector2(0,0):
		get_node("HappyBoo").play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	const DAMAGERATE = 100.0
	var overlap = %Hitbox.get_overlapping_bodies()
	if overlap.size()>0:
		health -= DAMAGERATE * overlap.size() * delta
		%HealthBar.value = health
		if health < 0.0:
			healthDepleted.emit()
	
