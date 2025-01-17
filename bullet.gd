extends Area2D

var travelDistance = 0

func _physics_process(delta: float):
	const SPEED = 800
	const RANGE = 1500
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelDistance += SPEED * delta
	if travelDistance >= RANGE:
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
	
