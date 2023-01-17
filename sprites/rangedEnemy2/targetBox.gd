extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func disable():
	#$CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	#$CollisionShape2D.disabled = false
	$CollisionShape2D.set_deferred("disabled", false)
