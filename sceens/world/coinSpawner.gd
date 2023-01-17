extends Node2D

var coinLoader = load("res://sprites/items/coin/coin.tscn")
var coin
var type = "coin"
var rng = RandomNumberGenerator.new()

func spawnCoin(coinSpawn):
	rng.randomize()
	if rng.randi_range(0,10) < 3:
		coin = coinLoader.instance()
		coin.position = coinSpawn
		add_child(coin)
