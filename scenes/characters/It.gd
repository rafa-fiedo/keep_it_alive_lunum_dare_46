extends KinematicBody2D

export(int) var speed = 32
export(float) var food_search_timer = 0.3 # in sec
export(bool) var god_mode = false

var closest_food = null
var velocity = Vector2()

signal player_died

func _ready():
	start_searching_food()
	

func _on_FoodDetector_area_entered(area):
	area.call_die()
	
	if $AnimationPlayer.current_animation == "Die" || $AnimationPlayer.current_animation == "Eating":
		return

	$AnimationPlayer.play("Eating")
	velocity = Vector2(0, 0)
	$Timer.stop() # it will be restart after eating animation
	closest_food = null

func _on_Timer_timeout():
	if $AnimationPlayer.current_animation == "Die":
		return
	$AnimationPlayer.play("Walking")
	var foods = []
	for child in get_parent().get_children():
		if child.name.find("Food") != -1:
			foods.append(child)
	
	if len(foods) == 0:
		# GIVE ME FOOD!
		closest_food = null
		return
	
	var min_distance = (foods[0].global_position - $Head.global_position).length()
	var min_node = foods[0]
	
	for i in range(1, len(foods)):
		var check_distance = (foods[i].global_position - $Head.global_position).length()
		
		if check_distance < min_distance:
			min_distance = check_distance
			min_node = foods[i]
	
	
	closest_food = min_node

func start_searching_food():
	$Timer.start(food_search_timer)

func _physics_process(_delta):
	if $AnimationPlayer.current_animation == "Die":
		return
		
	set_frames()
	if closest_food == null or !is_instance_valid(closest_food) or !(closest_food is Area2D):
		return
	
	if(global_position.distance_to(closest_food.global_position) < 2):
		return
	velocity = global_position.direction_to(closest_food.global_position) * speed
	
	velocity = move_and_slide(velocity)

func set_frames():
	if velocity.x == 0:
		return 
	var is_fliped = true if velocity.x > 0 else false
	
	$Sprite.flip_h = is_fliped
	$Head.position.x = 5 if is_fliped else -5


func _on_BulletDetector_body_entered(_body):
	call_deferred("die")
	
func die():
	if god_mode:
		return
	velocity = Vector2(0, 0)
	$Timer.stop()
	$AnimationPlayer.play("Die")
	
func game_over():
	emit_signal("player_died")
