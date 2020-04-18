extends Node2D


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("game_resume"):
		visible = false
		get_tree().paused = false
