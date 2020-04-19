extends Node2D


func _ready():
	pass


func _on_Button_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene("res://scenes/UI/Menu.tscn")
	if err != OK:
		print(err)


func _on_Button2_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible = false
	get_tree().paused = false
