extends Area2D

var target = Vector2()

func disable():
	#$CollisionShape2D.disabled = true
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	#$CollisionShape2D.disabled = false
	$CollisionShape2D.set_deferred("disabled", false)

func idleAnimation():
	$AnimatedSprite.animation = "idle"

func fireAnimation():
	$AnimatedSprite.animation = "fire"
	$AnimatedSprite.playing = true
	if get_node("/root/Global").hasSound:
		$fireSound.play(0.0)

func setFireAnimation(anim):
	$AnimatedSprite.frames = anim

# Movement
func trackPlayer(delta):
	# Movement
	var velocity = Vector2()
	
	# Movement
	if abs(position.x - target.x) > 5:
		if(position.x < target.x):
			velocity.x += 1
		else:
			velocity.x -= 1
	if abs(position.y - target.y) > 5:
		if(position.y < target.y):
			velocity.y += 1
		else:
			velocity.y -= 1
	
	# Animation
	# Right and left
	rotation_degrees = rad2deg(position.angle_to_point(target)) + 90
	# Movement update
	velocity = velocity.normalized() * get_parent().projectileSpeed
	position += velocity * delta
	
	if abs(position.y - target.y) <= 5 and abs(position.x - target.x) <= 5:
		idleAnimation()
		position = Vector2(0,0)
		get_parent().resetFire()
	
