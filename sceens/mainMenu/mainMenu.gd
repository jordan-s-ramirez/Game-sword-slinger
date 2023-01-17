extends Control

onready var screenSize = get_viewport().size

var state = 0


func _ready():
	# Configure Menu
	rect_size = screenSize
	rect_position = Vector2()
	
	# Backgound configure
	var scaleX = screenSize.x / $TextureRect.rect_size.x
	var scaleY = screenSize.y / $TextureRect.rect_size.y
	$TextureRect.rect_position = Vector2()
	$TextureRect.rect_scale = Vector2(scaleX,scaleY)
	$keys.animation = "up"

func _process(delta):
	# Walk up
	if state == 0:
		$hero.position.y -= (100 * delta)
	# Walk right
	elif state == 1:
		$hero.position.x += (100 * delta)
	# Walk Down
	elif state == 2:
		$hero.position.y += (100 * delta)
	# Walk Left
	elif state == 3:
		$hero.position.x -= (100 * delta)
	# Throw Sword
	elif state == 4:
		$hero.throwSword(delta)
	elif state == 5:
		$hero.throwReturn(delta)

func _on_Start_pressed():
	get_tree().change_scene("res://sceens/world/world.tscn")


func _on_playerMovement_timeout():
	if state > 4:
		state = -1
	else:
		# Update State
		state += 1
		
	# Walk up
	if state == 0:
		$hero.removeSword()
		$hero.play("up")
		$keys.animation = "up"
	# Walk right
	elif state == 1:
		$hero.animation = "right"
		$keys.animation = "right"
	# Walk Down
	elif state == 2:
		$hero.animation = "down"
		$keys.animation = "down"
	# Walk left
	elif state == 3:
		$hero.animation = "left"
		$keys.animation = "left"
	# Throw Sword
	elif state == 4:
		$hero.stop()
		$keys.animation = "spacebar"
		$hero.setSword()
	elif state == 5:
		$keys.animation = "idle"
