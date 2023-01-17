extends KinematicBody2D

# Enemy Stats
var damage = 0.05
var health = 0.25
var maxHealth = 0.25
var speed = 50
const type = "enemy"

# Movement
var velocity = Vector2()
var playerPosition = Vector2()

# Animation
onready var _animated_sprite = get_node("AnimatedSprite")
var direction = 0
var hurtTimer = 0.5
var timer = 100

# Gets Player
onready var _player = get_parent().player
onready var coinSpawner = get_parent().coinSpawner

# Enemy Spawn
onready var rng = RandomNumberGenerator.new()

func get_input():
	# Movement
	velocity = Vector2() + $collisionBox.get_push_vector()
	playerPosition = Vector2(_player.position.x, _player.position.y)
	
	# Movement
	if(position.x < playerPosition.x):
		velocity.x += 1
	else:
		velocity.x -= 1
	if(position.y < playerPosition.y):
		velocity.y += 1
	else:
		velocity.y -= 1
	
	# Animation
	# Right and left
	if(abs(position.x - playerPosition.x) > 5):
		if(position.x < playerPosition.x):
			_animated_sprite.play("right")
		else:
			_animated_sprite.play("left")
	# Top and bottom
	elif(abs(position.y - playerPosition.y) > 5):
		if(position.y < playerPosition.y):
			_animated_sprite.play("down")
		else:
			_animated_sprite.play("up")
	
	# Movement update
	velocity = velocity.normalized() * speed
	
func _process(_delta):
	# Game is paused
	if get_parent().isPaused:
		return
			
	if health > 0.0:
		get_input()	
	else:
		if $AnimationPlayer.current_animation != "spriteDead":
			$AnimationPlayer.play("spriteDead")
	
	var collision = move_and_collide((velocity + $collisionBox.get_push_vector()) * _delta)

func _ready():
	# Spawn Random type (Commom mob)
	rng.randomize()
	var typeMob = rng.randi_range(1,4)
	var enemyAnimation = load("res://sprites/commonEnemy/enemySpriteFrames/enemy"+str(typeMob)+"SF.tres")
	$AnimatedSprite.frames = enemyAnimation
	if typeMob == 3 or typeMob == 4:
		health *= 1.5
		maxHealth *= 1.5
	
	# Default animation
	_animated_sprite.play("down")
	$AnimationPlayer.play("spriteIdle")
	
	# Inialization
	scale = Vector2(1.5,1.5)

func _on_enemyHitbox_area_entered(area):
	var object = area.get_parent()
	if object.type == "sword":
		$AnimationPlayer.play("spriteshurt")
		$hitTimer.start(0.5)
		if get_parent().hasSound:
			$hitSound.play(0.0)
		timer = hurtTimer
		health -= object.damage

func _on_hitTimer_timeout():
	$AnimationPlayer.play("spriteIdle")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spriteDead":
		# Increase Score
		get_parent().score += maxHealth * 100
		# Maybe spawn coin
		coinSpawner.spawnCoin(position)
		# Delete if dead
		queue_free()
