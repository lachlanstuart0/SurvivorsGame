extends CharacterBody2D

var health = 100.0
signal healthDepleted
var playerState

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
	
	var itemOverlap = %PickupBox.get_overlapping_bodies()
	if itemOverlap.size() > 0:
		for item in itemOverlap:
			#print(item)
			if item.type == "Invince":
				%InvinceTimer.start()
				health = 100
				%HealthBar.value = health
				%Invince.visible = true
			
			item.queue_free()
	
	#skips damage step if invincible
	if %Invince.visible == true:
		return
	
	const DAMAGERATE = 100.0
	var overlap = %Hitbox.get_overlapping_bodies()
	if overlap.size()>0:
		
		for body in overlap:
			health -= DAMAGERATE * delta
			%HealthBar.value = health
			if health < 0.0:
				healthDepleted.emit()
	


func _on_invince_timer_timeout() -> void:
	%Invince.visible = false
	pass # Replace with function body.
