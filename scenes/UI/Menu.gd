extends Control


func _ready():
	$Music.play(1)
	pass # Replace with function body.

func _on_Button_pressed():
	var err = get_tree().change_scene("res://scenes/levels/MainLevel1.tscn")
	if err != OK:
		print(err)


func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(meta)
	if err != OK:
		print(err)


func _on_Button2_pressed():
	var err = get_tree().change_scene("res://scenes/levels/MainLevel2.tscn")
	if err != OK:
		print(err)


func _on_Button3_pressed():
	var err = get_tree().change_scene("res://scenes/levels/MainLevel3.tscn")
	if err != OK:
		print(err)
