extends KinematicBody2D

# Sword stats
const type = "sword"
var damage = 0.05
var hasOwner = false
var speed = 200
var throwDistance = 250

# Movement
var velocity = Vector2.ZERO

# Next sword
var queNext = false

# throwing sword
var target = Vector2()
var isThrowing = false
var isLanding = false

# Player
onready var player = get_parent().player

func _ready():
	$collisionBox.disable()
	$attackBox.disable()
	$AnimatedSprite.animation = "default"


func swordMovement():
	velocity = Vector2()
	# X direction
	if abs(position.x - target.x) > 5:
		if position.x < target.x:
			velocity.x += 1
		else:
			velocity.x -= 1
			
	# Y direction	
	if abs(position.y - target.y) > 5:
		if position.y < target.y:
			velocity.y += 1
		else:
			velocity.y -= 1
	
	# Found target
	if isLanding:
		target = player.position
		$searchBox.enable()
	elif abs(position.y - target.y) <= 5 and abs(position.x - target.x) <= 5:
		# Set new target back to player
		target = player.position
		isLanding = true
		# Configure hitboxes
		$searchBox.enable()
	
func throwSword():
	if Input.is_action_pressed("ui_accept"):
		hasOwner = false
		player.hasWeapon = false
		isThrowing = true
		$AnimatedSprite.animation = "default"
		
		# Play Sound
		if get_parent().hasSound:
			$swordThrow.play(0.0)
		
		# Set target
		target = player.position
		if player.direction == "down":
			target.y += throwDistance
		elif player.direction == "up":
			target.y -= throwDistance
		elif player.direction == "left":
			target.x -= throwDistance
		elif player.direction == "right":
			target.x += throwDistance
		
		# Set attack for enemy
		$attackBox.enable()
		$collisionBox.enable()

func positionSword():
	position = player.position
	if player.direction == "down":
		position.x -= 13
		position.y += 25	
		rotation_degrees = 180
		#if rotation_degrees < 195 and rotation_degrees >= 175:
			#rotation_degrees += 0.1
		#else:
			
	elif player.direction == "up":
		position.x += 15
		position.y -= 15
		rotation_degrees = 0
	elif player.direction == "left":
		rotation_degrees = 270
	elif player.direction == "right":
		rotation_degrees = 90
		position.y += 5
		# Launching 

func _process(delta):
	# Game is paused
	if get_parent().isPaused:
		return
	
	if hasOwner:
		positionSword()
		throwSword()
	
	if isThrowing:
		# Movement
		swordMovement()
		velocity = velocity.normalized() * speed
		var collision = move_and_collide(velocity * delta)
		
		# Rotation
		rotation_degrees += 15
		if rotation_degrees > 360:
			rotation_degrees = 0
	
	# Pick up sword then player is throwing and on top of new sword
	if queNext:
		if !player.hasWeapon:
			# Set weapon to owner
			hasOwner = true
			$AnimatedSprite.animation = "idle"
			player.hasWeapon = true
			rotation_degrees = 0
			queNext = false
			$attackBox.enable()
			$searchBox.disable()

func _on_searchBox_area_entered(area):
	var object = area.get_parent()
	if object.type == "player":
		if !object.hasWeapon:
			# Set weapon to owner
			hasOwner = true
			$AnimatedSprite.animation = "idle"
			object.hasWeapon = true
			rotation_degrees = 0
			$attackBox.enable()
			$searchBox.disable()
		elif isThrowing:
			$collisionBox.disable()
			$attackBox.disable()
			isThrowing = false
			isLanding = false
		else:
			queNext = true

func _on_searchBox_area_exited(area):
	var object = area.get_parent()
	if object.type == "player":
		queNext = false
		#print("quenext is false")
