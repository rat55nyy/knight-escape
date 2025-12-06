extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player": 
		
		body.gain_experience(10)
		
		queue_free()
