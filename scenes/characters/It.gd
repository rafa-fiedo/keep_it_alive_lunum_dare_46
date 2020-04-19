extends KinematicBody2D

export(int) var speed = 32
export(float) var food_search_timer = 0.2 # in sec
export(bool) var god_mode = false

var closest_food = null
var velocity = Vector2()

var banned_foods = []

signal player_died

func _ready():
	start_searching_food()

func _on_FoodDetector_area_entered(area):
	area.call_die()
	
	if $AnimationPlayer.current_animation == "Die" || $AnimationPlayer.current_animation == "Eating":
		return

	animation_change("Eating")
	velocity = Vector2(0, 0)
	$Timer.stop() # it will be restart after eating animation
	$TimerHelper.start()
	closest_food = null

func _on_Timer_timeout():
	if closest_food != null:
		if $RayCast2D.is_colliding():
			if is_instance_valid(closest_food):
				banned_foods.append(closest_food.get_instance_id())
	
	if $AnimationPlayer.current_animation == "Die":
		return
	animation_change("Walking")
	var foods = []
	for child in get_parent().get_children():
		if child.name.find("Food") != -1:
			foods.append(child)
	
	if len(foods) == 0:
		# GIVE ME FOOD!
		closest_food = null
		return
	
	var min_distance = 9999999
	var min_node = null
	
	for i in range(0, len(foods)):
		if banned_foods.has(foods[i].get_instance_id()):
			continue
		
		var check_distance = (foods[i].global_position - $Head.global_position).length()
		
		if check_distance < min_distance:
			min_distance = check_distance
			min_node = foods[i]
	
	if min_node != null:
		$RayCast2D.enabled = true
		$RayCast2D.cast_to = (min_node.global_position - $Head.global_position) * 0.9
		
	closest_food = min_node

func start_searching_food():
	$Timer.start(food_search_timer)

func _physics_process(_delta):
	if $AnimationPlayer.current_animation == "Die":
		return
		
	set_frames()
	if closest_food == null or !is_instance_valid(closest_food) or !(closest_food is Area2D):
		return
	
	if(global_position.distance_to(closest_food.global_position) < 1):
		return
	velocity = global_position.direction_to(closest_food.global_position) * speed
	
	velocity = move_and_slide(velocity)

func set_frames():
	if velocity.x == 0:
		return 
	var is_fliped = true if velocity.x > 0 else false
	
	$Sprite.flip_h = is_fliped
	$Head.position.x = 5.5 if is_fliped else -5.5

func animation_change(new_animation):
	if $AnimationPlayer.current_animation == new_animation:
		return
		
	$AnimationPlayer.play(new_animation)

func _on_BulletDetector_body_entered(_body):
	call_deferred("die")
	
func die():
	if god_mode:
		return
		
	get_parent().find_node("Music").stop()
	get_parent().find_node("DeadMusic").play()
	velocity = Vector2(0, 0)
	$Timer.stop()
	animation_change("Die")
	
func game_over():
	emit_signal("player_died")

func play_eating_sound():
	var r = randf()
	
	var mniam_wav = "res://assets/audio/samples/mniam_1.wav"
	
	if r >= 0.7 and r < 0.8:
		mniam_wav = "res://assets/audio/samples/mniam_2.wav"
	elif r >= 0.8 and r < 0.9:
		mniam_wav = "res://assets/audio/samples/mniam_3.wav"
	elif r >= 0.9:
		mniam_wav = "res://assets/audio/samples/mniam_4.wav"
	
	$SoundEffects.stream = load(mniam_wav)
	$SoundEffects.play()
	

func _on_TimerHelper_timeout():
	if $Timer.time_left == 0:
		$Timer.start(food_search_timer)
