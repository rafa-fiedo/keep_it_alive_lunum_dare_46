extends CanvasLayer

func _ready():
	pass # Replace with function body.


func _on_TryAgain_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene("res://scenes/levels/MainLevel.tscn")
	if err != OK:
		print(err)

func _on_Menu_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene("res://scenes/UI/Menu.tscn")
	if err != OK:
		print(err)
