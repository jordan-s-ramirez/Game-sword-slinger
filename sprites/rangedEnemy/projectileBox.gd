extends Area2D

var target = Vector2()
var isLanded = false

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

# Movement
func trackPlayer(delta):
	# Movement
	var velocity = Vector2()
	
	# Movement
	if(position.x < target.x):
		velocity.x += 1
	else:
		velocity.x -= 1
	if(position.y < target.y):
		velocity.y += 1
	else:
		velocity.y -= 1
	
	# Animation
	# Right and left
	rotation_degrees += 30
	if(rotation_degrees > 360):
		rotation_degrees = 1
	# Movement update
	velocity = velocity.normalized() * get_parent().projectileSpeed
	position += velocity * delta
	
	if abs(position.y - target.y) <= 5 and abs(position.x - target.x) <= 5:
		if isLanded:
			idleAnimation()
			position = Vector2(0,0)
			isLanded = false
			get_parent().resetFire()
		else:
			# Set new target back to player
			target = Vector2(0,0)
			isLanded = true
	
