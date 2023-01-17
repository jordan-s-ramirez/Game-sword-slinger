extends AnimatedSprite


func attack(delta):
	position.x -= 150 * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if isAttacking:
	#	position.x -= 150 * delta
