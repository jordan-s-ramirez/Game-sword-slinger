extends KinematicBody2D

# Movement
export (int) var speed = 100
var velocity = Vector2()

# Animation
onready var _animated_sprite = get_node("AnimatedSprite")
var hurtTimer = 0.5
var timer = 100

# Player Stats
var health = 1.0
var maxHealth = 1.0
const type = "player"
var hasWeapon = false
var direction = "down"

func _ready():
	_animated_sprite.play("down")
	_animated_sprite.stop()
	$AnimationSword.play("animSwordDown")
	$AnimationSword.stop(false)

func get_input():
	# Movement
	velocity = Vector2()
	
	# On key release
	if Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_right"):
		_animated_sprite.stop()
		$AnimationSword.stop(false)
		
	# Left and Right
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		_animated_sprite.play("right")
		direction = "right"
		$AnimationSword.play("animSwordRight")
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		_animated_sprite.play("left")
		$AnimationSword.play("animSwordLeft")
		direction = "left"
	# Up and Down
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		_animated_sprite.play("down")
		direction = "down"
		$AnimationSword.play("animSwordDown")
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		_animated_sprite.play("up")
		$AnimationSword.play("animSwordUp")
		direction = "up"
	
	# Movement update
	velocity = velocity.normalized() *speed

func animSword():
	if hasWeapon:
		if $AnimatedSword.animation != "hold":
			$AnimatedSword.animation = "hold"
	else:
		$AnimatedSword.animation = "idle"

func _physics_process(delta):
	# If game is paused
	if get_parent().isPaused:
		return
	
	$ProgressBar.value = health / maxHealth
	if health > 0.0:
		# Health Bar
		# Movement
		get_input()
		animSword()
		var collision = move_and_collide(velocity * delta)

func _on_playerHitbox_area_entered(area):
	var object = area.get_parent()
	var hasSound = get_parent().hasSound
	if object.type == "enemy":
		if hasSound:
			$playerHit.play(0.0)
		$AnimationPlayer.play("spriteshurt")
		$hitTimer.start(0.5)
		health -= object.damage
		print(health)
	elif object.type == "healthPack":
		if hasSound:
			$healed.play(0.0)
		health = 1
	#elif object.type == "coin":
	#	get_parent().score += 500

# Stop hit animation
func _on_hitTimer_timeout():
	$AnimationPlayer.play("spriteIdle")
