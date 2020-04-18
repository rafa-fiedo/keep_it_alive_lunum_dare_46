extends Node2D

onready var food_scene = load("res://scenes/characters/Food.tscn")

var is_hand_on_the_ground = true

func _ready():
	
	pass # Replace with function body.

func _process(_delta):
	global_position = get_global_mouse_position()

func _input(event):
		
	if event.is_action_pressed("game_use_hand"):
		if !is_hand_on_the_ground:
			$AnimationPlayer.play("Cancel")
			return
		
		$AnimationPlayer.play("Spawn")
		
		var mouse_p = get_global_mouse_position()
	
		var food_node = food_scene.instance()
		food_node.global_position = mouse_p
		get_parent().add_child(food_node)
		

func _on_CollisionDetector_body_entered(_body):
	is_hand_on_the_ground = false

func _on_CollisionDetector_body_exited(_body):
	is_hand_on_the_ground = true
