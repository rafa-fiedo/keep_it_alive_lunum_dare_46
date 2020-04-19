extends KinematicBody2D

onready var bullet_scene = load("res://scenes/enemies/Bullet.tscn")
onready var score_popup_scene = load("res://scenes/UI/ScorePopup.tscn")

var shoot_time = 6
var score_points = 15

var is_dead = false

signal enemy_dead

# Called when the node enters the scene tree for the first time.
func _ready():

	var closest_it = find_closest_it()
	if closest_it == null:
		return
		
	set_frames(closest_it.find_node("Head"))
	
	var err = connect("enemy_dead", get_parent(), "on_enemy_died", [score_points])
	if err != OK:
		print(err)
	
	start_aiming()

func _on_BowAiming_timeout():
	var closest_it = find_closest_it()
	if closest_it == null:
		return

	$Sprite/Bow.rotation = $ShootStartPosition.global_position.angle_to_point(closest_it.find_node("Head").global_position)

func _on_BulletDetector_body_entered(_body):
	die()

func _on_ShootTimer_timeout():
	if !is_dead:

		$AnimationPlayer.play("Shoot")

func start_aiming():
	# shoot time can't be shorter than animation
	$ShootTimer.start(max(1, shoot_time - 1))
		


func shoot():
	# invoked from animation player
	$Samples.stream = load("res://assets/audio/samples/arrow_start.wav")
	$Samples.play()
	$AnimationPlayer.play("Idle")
	var bullet = bullet_scene.instance()
	
	var closest_it = find_closest_it()
	if closest_it == null:
		return
	bullet.position = $ShootStartPosition.global_position
	var it_head = closest_it.find_node("Head")
	bullet.target = it_head.global_position
	get_parent().add_child(bullet)
	
	set_frames(it_head)
	start_aiming()


func find_closest_it():
	# hardcoded because of gamejam :P
	
	var its = []
	var it_node = get_parent().find_node("It")
	if it_node:
		its.append(it_node)
		
	it_node = get_parent().find_node("It2")
	if it_node:
		its.append(it_node)
		
	it_node = get_parent().find_node("It3")
	if it_node:
		its.append(it_node)
		
	if len(its) == 0:
		return null
	
	var closest_it = its[0]
	var closest_dis = global_position.distance_to(its[0].global_position)
	
	for i in range(1, len(its)):
		var next_it = its[i]
		var distance = global_position.distance_to(next_it.global_position)
		if distance < closest_dis:
			closest_dis = distance
			closest_it = next_it
	
	return closest_it

func set_frames(it_head):
	var is_flip = true if it_head.global_position.x > global_position.x else false
	$Sprite.flip_h = is_flip

func call_die():
	call_deferred("die")
	
func die():
	if !is_dead:
		is_dead = true
		$AnimationPlayer.play("Die")
		emit_signal("enemy_dead")
		$ShootTimer.stop()
		$BowAiming.stop()
		
		var score_popup = score_popup_scene.instance()
		score_popup.position = Vector2(0, -16)
		score_popup.set_score(score_points)
		add_child(score_popup)



