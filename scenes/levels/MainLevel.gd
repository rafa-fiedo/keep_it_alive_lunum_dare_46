extends Node2D

var boat_scene = load("res://scenes/enemies/Boat.tscn")
var results_scene = load("res://scenes/UI/Results.tscn")

export(int) var level_no = 1

var score = 0
var score_per_sec = 1
var killed_enemies = 0
var spawn_time = 9

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	spawn_boat()
	spawn_boat()
	$BoatPath/SpawnTImer.start(spawn_time)
	
func _input(event):
	if event.is_action_pressed("game_resume"):
		$Pause.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func on_enemy_died(score_value):
	score += score_value
	killed_enemies += 1
	

func _on_ScoreTimer_timeout():
	score += score_per_sec
	$Score.text = str(score)
	
func _on_SpawnTImer_timeout():
	spawn_boat()
	
func _on_It_player_died():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	var results = results_scene.instance()
	results.level_no = level_no
	results.find_node("Score").bbcode_text = \
		"[center]Total score: " + str(score) + "[/center]" + \
		"[center]Killed enemies: " + str(killed_enemies) + "[/center]"
	add_child(results)
	
func spawn_boat():
	$BoatPath/PathFollow2D.unit_offset = randf()
	
	var its = []
	var it_node = find_node("It")
	if it_node:
		its.append(it_node)
		
	it_node = find_node("It2")
	if it_node:
		its.append(it_node)
		
	it_node = find_node("It3")
	if it_node:
		its.append(it_node)
		
	if len(its) == 0:
		return null
		
	var it_no = randi() % len(its) + 1
	
	var boat = boat_scene.instance()
	boat.position = $BoatPath/PathFollow2D.global_position
	
	if it_no == 1:
		boat.target = $It.global_position
	elif it_no == 2:
		boat.target = $It2.global_position
	elif it_no == 3:
		boat.target = $It3.global_position
	
	add_child(boat)



func _on_HardTimer1_timeout():
	print("hardtimer_1")
	spawn_time -= 2
	score_per_sec += 1
	$BoatPath/SpawnTImer.start(spawn_time)

func _on_HardTimer2_timeout():
	print("hardtimer_2")
	spawn_time -= 1
	score_per_sec += 1
	$BoatPath/SpawnTImer.start(spawn_time)

func _on_HardTimer3_timeout():
	print("hardtimer_3")
	spawn_time -= 2
	score_per_sec += 1
	$BoatPath/SpawnTImer.start(spawn_time)
