extends Control

onready var parent = get_parent()

func _ready():
	anchor_bottom = 0.5
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.5
	#$gameOverLabel.rect_position = Vector2.ZERO
	rect_position = parent.camera.position - (rect_size / 2)
	rect_position.y -= 100
	
	# Position Score
	$score.text = "Score: " + str(parent.score)
	$score.anchor_bottom = 0.5
	$score.anchor_left = 0.5
	$score.anchor_right = 0.5
	$score.anchor_top = 0.5
	$score.rect_position.y += 50
	var scoreSize = $score.rect_size
	$score.rect_position.x = (rect_size.x / 2) - (scoreSize.x / 2)
	
	# Position restart button
	$restart.rect_position.y += 75
	$restart.rect_position.x = (rect_size.x / 2) - ($restart.rect_position.x / 2)
	
func _on_restart_pressed():
	# Queue restart game
	get_tree().reload_current_scene()
