extends KinematicBody2D

# Movement
var velocity = Vector2.ZERO
var isSearching = true

# Stats
var type = "enemy"
var speed = 125
var projectileSpeed = 125
var damage = 0.05
var health = 0.75
var maxHealth = 0.75

# Player
onready var player = get_parent().player
var playerPosition = Vector2()
onready var coinSpawner = get_parent().coinSpawner

# Rng
var rng = RandomNumberGenerator.new()

# Movement
func get_input():
	# Movement
	velocity = Vector2() + $collisionBox.get_push_vector()
	playerPosition = Vector2(player.position.x, player.position.y)
	
	# Movement
	if(abs(position.x - playerPosition.x) > 5):
		if(position.x < playerPosition.x):
			velocity.x += 1
		else:
			velocity.x -= 1
	if(abs(position.y - playerPosition.y) > 5):
		if(position.y < playerPosition.y):
			velocity.y += 1
		else:
			velocity.y -= 1
	
	# Animation
	# Right and left
	if(abs(position.x - playerPosition.x) > 5):
		if(position.x < playerPosition.x):
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
	
	# Movement update
	velocity = velocity.normalized() * speed
	

func _ready():
		# Spawn Random type (Commom mob)
	rng.randomize()
	var typeMob = rng.randi_range(1,3)
	var enemyAnimation = load("res://sprites/rangedEnemy2/enemyAnimations/enemy"+str(typeMob)+".tres")
	var enemyFireAnmation = load("res://sprites/rangedEnemy2/fireAnimations/fire"+str(typeMob)+".tres")
	$AnimatedSprite.frames = enemyAnimation
	$projectileBox.setFireAnimation(enemyFireAnmation)
	
	
	# Projectile should be disabled
	$projectileBox.disable()
	$AnimatedSprite.animation = "down"


func resetFire():
	$projectileBox.disable()
	$targetBox.enable()
	isSearching = true
	$AnimatedSprite.animation = "down"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Game is paused
	if get_parent().isPaused:
		return
	if health > 0.0:
		if player.health > 0.0:
			if isSearching:
				# Movement
				get_input()
				var collision = move_and_collide((velocity + $collisionBox.get_push_vector()) * delta)
			else:
				$projectileBox.trackPlayer(delta)
	else:
		if $AnimationPlayer.current_animation != "spriteDead":
			$AnimationPlayer.play("spriteDead")

func _on_targetBox_area_entered(area):
	# Target Player
	var object = area.get_parent()
	if object.type == "player":
		$targetBox.disable()
		$projectileBox.enable()
		$projectileBox.fireAnimation()
		$projectileBox.target = player.position - position
		isSearching = false

func _on_hitBox_area_entered(area):
	var object = area.get_parent()
	var hasSound = get_parent().hasSound
	if object.type == "sword":
		$AnimationPlayer.play("spriteshurt")
		$hurtTimer.start(0.5)
		if hasSound:
			$hitSound.play(0.0)
		health -= object.damage

# Animation goes back to idle
func _on_hurtTimer_timeout():
	$AnimationPlayer.play("spriteIdle")

# On Death
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spriteDead":
		# Increase Score
		get_parent().score += maxHealth * 150
		# Maybe spawn coin
		coinSpawner.spawnCoin(position)
		# Delete if dead
		queue_free()

