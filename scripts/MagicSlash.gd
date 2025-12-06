extends Area2D

var damage = 10 

func _ready():
	body_entered.connect(_on_body_entered)
	
	var sprite = $AnimatedSprite2D
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("default") 

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_animation_finished():
	queue_free() 
