extends Control


func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/levels/MainLevel.tscn")


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
