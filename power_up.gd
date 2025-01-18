extends StaticBody2D

var type

func _physics_process(delta: float):
	play_bob_animation()

func play_bob_animation():
	%AnimationPlayer.play("bob")
