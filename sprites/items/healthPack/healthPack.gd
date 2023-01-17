extends Node2D

var type = "healthPack"

func _on_healHitBox_area_entered(area):
	var object = area.get_parent()
	if object.type == "player":
		queue_free()
