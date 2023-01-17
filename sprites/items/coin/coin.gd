extends Node2D

var type = "coin"
var value = 100
func _on_coin_area_entered(area):
	var object = area.get_parent()
	if object.type == "player":
		get_parent().get_parent().score += value
		queue_free()
