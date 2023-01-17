extends Node2D

# Declare member variables here. Examples:
onready var playerLoader = load('res://sprites/player/player.tscn')
onready var enemyLoader  = load("res://sprites/commonEnemy/commonEnemy.tscn")
onready var swordLoader = load('res://sprites/sword/sword.tscn')
onready var healthLoader = load('res://sprites/items/healthPack/healthPack.tscn')
onready var rangedEnemyLoader  = load("res://sprites/rangedEnemy/rangedEnemy.tscn")
onready var rangedEnemy2Loader = load("res://sprites/rangedEnemy2/rangedEnemy2.tscn")
onready var camera = $Camera2D
onready var screenSize = camera.get_viewport().size
onready var cameraDirection = screenSize / 2;
onready var cameraZero = camera.position - cameraDirection

# Game
var score = 0
var isPaused = false
var hasSound = true
var player
var enemy
var rangedEnemy
var rangedEnemy2 = null
var sword

# Global Vars
onready var globalVars = get_node("/root/Global")
onready var coinSpawner = get_node("coinSpawner")

# Level
var level = 1
onready var rng = RandomNumberGenerator.new() # Spawning
var numbNodes

# Game Over
var gameOverAdder = true
	
func setEnemySpawn():
	var buffer = camera.get_viewport().size / 2
	var spawn = Vector2(camera.position.x, camera.position.y)
	var zone = rng.randi_range(0,3)
	
	if zone == 3:
		spawn.x += buffer.x
		spawn.y = rng.randi_range(0,(buffer.y * 2))
	elif zone == 2:
		spawn.y += buffer.y
		spawn.x = rng.randi_range(0,(buffer.x * 2))
	elif zone == 1:
		spawn.x -= buffer.x
		spawn.y = rng.randi_range(0,(buffer.y * 2))
	else:
		spawn.y -= buffer.y
		spawn.x = rng.randi_range(0,(buffer.x * 2))
	
	return spawn

func edgeOfScreen():
	var absX = player.position.x - cameraZero.x
	var absY = player.position.y - cameraZero.y
	
	if(absX < 0):
		player.position = Vector2(screenSize.x - 1, absY) + cameraZero
	elif(absX > screenSize.x):
		player.position = Vector2(1, absY) + cameraZero
		
	if(absY < 0):
		player.position = Vector2(absX, screenSize.y - 1) + cameraZero
	elif(absY > screenSize.y):
		player.position = Vector2(absX, 1) + cameraZero

func spawn():
	# Spawn enemies
	rng.randomize()
	for _x in range(level):
		enemy = enemyLoader.instance()
		enemy.position = setEnemySpawn()
		add_child(enemy);
		enemy = null
			
	# Spawn ranged enemy
	if (level % 2) == 0:
		for _x in range(int(level/2)):
			print("Spawn Ranged")
			rangedEnemy = rangedEnemyLoader.instance()
			#rangedEnemy = rangedEnemyLoader.instance()
			rangedEnemy.position = setEnemySpawn()
			add_child(rangedEnemy)
			rangedEnemy = null
	
	# Spawn ranged enemy
	if (level % 3) == 0:
		for _x in range(int(level/2)):
			rangedEnemy2 = rangedEnemy2Loader.instance()
			rangedEnemy2.position = setEnemySpawn()
			add_child(rangedEnemy2)
			rangedEnemy2 = null

func _ready():
	# Configure has Sound icon
	if !globalVars.hasSound:
		hasSound = false
		$music.stream_paused = true
		$musicButton.icon = load("res://sceens/world/worldAssets/musicButtonIcons/mute.tres")
	else:
		hasSound = true
		$music.stream_paused = false
		$musicButton.icon = load("res://sceens/world/worldAssets/musicButtonIcons/speaker.tres")
		
	# Backgound configure
	camera.position = Vector2(0,0)
	var scaleX = screenSize.x / $TextureRect.rect_size.x
	var scaleY = screenSize.y / $TextureRect.rect_size.y
	$TextureRect.rect_scale = Vector2(scaleX,scaleY)
	$TextureRect.rect_position = - screenSize / 2
	
	# Configure Level Screen
	$level.text = ""
	
	# Configure Score
	$score.rect_position = camera.position - cameraDirection 
	$score.rect_position += Vector2(5,5)
	# Add Player at the center of screen
	player = playerLoader.instance()
	player.position = camera.position
	add_child(player);
	
	# Add Sword
	sword = swordLoader.instance()
	sword.position = camera.position
	add_child(sword);
	
	# Set number of nodes before adding enemy
	numbNodes = get_child_count() 
	
	# Spawn on enemy
	rng.randomize()
	var enemy = enemyLoader.instance()
	enemy.position = setEnemySpawn()
	print(enemy.position)
	print(player.position)
	add_child(enemy);
	enemy = null

func _process(_delta):
	if player.health > 0.0:
		edgeOfScreen()
		$score.text = "Level: " + str(level) + "\nScore: " + str(score)
		while get_child_count() <= numbNodes && !$spawnEnemies.time_left:
			# Increase level
			level += 1
			$level.text = "LEVEL: " + str(level)
			
			# Spawn sword every 6 levels
			if (level % 6) == 0:
				sword = swordLoader.instance()
				sword.position = camera.position
				add_child(sword)
				numbNodes += 1
			# Chance to spawn health pack
			if (player.health / player.maxHealth) <= 0.3 :
				# Add healthpacks
				var healthPack = healthLoader.instance()
				healthPack.position = camera.position
				add_child(healthPack)
				
			$spawnEnemies.start(5)
	else:
		#Add Only once
		if gameOverAdder:
			gameOverAdder = false
			add_child(load("res://sceens/world/worldComponents/gameOver/gameOver.tscn").instance())

func _on_pauseButton_toggled(button_pressed):
	if button_pressed:
		isPaused = true
		$pauseButton.icon = load("res://sceens/world/worldAssets/pauseButton/play.tres")
		$pauseButton.rect_position.x += 5
	else:
		isPaused = false
		$pauseButton.icon = load("res://sceens/world/worldAssets/pauseButton/pause.tres")
		$pauseButton.rect_position.x -= 5

func _on_musicButton_toggled(button_pressed):
	if button_pressed:
		globalVars.hasSound = false
		hasSound = false
		$music.stream_paused = true
		$musicButton.icon = load("res://sceens/world/worldAssets/musicButtonIcons/mute.tres")
	else:
		globalVars.hasSound = false
		hasSound = true
		$music.stream_paused = false
		$musicButton.icon = load("res://sceens/world/worldAssets/musicButtonIcons/speaker.tres")
		
func _on_spawnEnemies_timeout():
	spawn()
	$level.text = ""
