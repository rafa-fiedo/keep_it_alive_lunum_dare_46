extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func die():
	$AnimationPlayer.play("Die")

func call_die():
	call_deferred("die")

func _on_WaterDetector_body_entered(_body):
	$AnimationPlayer.play("WaterDie")

func call_water_die_effect():
	# maybe 
	return
#	$Sprite.visible = false
#	$WaterDieEffect.emitting = true
	
