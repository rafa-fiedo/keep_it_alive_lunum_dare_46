extends Node2D

var boat_scene = load("res://scenes/enemies/Boat.tscn")
var results_scene = load("res://scenes/UI/Results.tscn")

var score = 0
var killed_enemies = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	spawn_boat()
	
func _input(event):
	if event.is_action_pressed("game_pause"):
		$Pause.visible = true
		get_tree().paused = true

func _on_ScoreTimer_timeout():
	score += 1
	$Score.text = str(score)
	
func _on_SpawnTImer_timeout():
	spawn_boat()
	
func _on_It_player_died():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	var results = results_scene.instance()
	results.find_node("Score").bbcode_text = \
		"[center]Total score: " + str(score) + "[/center]" + \
		"[center]Killed enemies: " + str(killed_enemies) + "[/center]"
	add_child(results)
	
func spawn_boat():
	$BoatPath/PathFollow2D.unit_offset = randf()
	
	var boat = boat_scene.instance()
	boat.position = $BoatPath/PathFollow2D.global_position
	boat.target = $It.global_position
	
	add_child(boat)




