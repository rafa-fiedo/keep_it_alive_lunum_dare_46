extends KinematicBody2D

var speed = 64
var velocity = Vector2()

var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = global_position.angle_to_point(target)
	velocity = global_position.direction_to(target) * speed

func _physics_process(_delta):
	velocity = move_and_slide(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ImmortalityTimer_timeout():
	$CollisionShape2D.disabled = false
