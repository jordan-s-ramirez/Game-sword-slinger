extends Area2D

func disable():
	#$CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	#$CollisionShape2D.disabled = false
	$CollisionShape2D.set_deferred("disabled", false)
