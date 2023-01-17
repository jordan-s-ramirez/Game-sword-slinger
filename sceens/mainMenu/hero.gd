extends AnimatedSprite

var speed = 150
var throwRange = 200
var direction = -1
func removeSword():
	direction = -1
	$sword.animation = "idle"
	$sword.position = Vector2.ZERO

func setSword():
	$sword.animation = "attack"

func throwSword(delta):
	$sword.position.x += speed * delta * direction
	$sword.rotation_degrees += 15
	if $sword.position.x <= (throwRange * direction):
		direction = 1
	
func throwReturn(delta):
	$sword.position.x += speed * delta * direction
	$sword.rotation_degrees += 15
	
	if $sword.position.x > 0:
		$sword.animation = "idle"
