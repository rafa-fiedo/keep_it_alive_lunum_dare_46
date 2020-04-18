extends KinematicBody2D

export(PackedScene) var enemy_scene

var velocity = Vector2()
var speed = 8
var target = Vector2()

func _ready():
	velocity = global_position.direction_to(target) * speed

func _physics_process(delta):
	pass
	var collision = move_and_collide(velocity * delta)
	if collision:
		spawn_enemies(collision)
		set_physics_process(false)
		

func spawn_enemies(collision):
	var enemy_node = enemy_scene.instance()
	enemy_node.position = collision.position + (-collision.normal * 10)
	
	get_parent().add_child(enemy_node)
