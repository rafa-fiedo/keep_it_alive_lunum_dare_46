extends Node2D

func _ready():
	pass

func set_score(score):
	$Label.text = "+" + str(score) + "!"
