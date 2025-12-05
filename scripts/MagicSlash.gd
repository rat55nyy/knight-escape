extends Area2D

var damage = 10 

func _ready():
	# 1. Conectar colisión
	body_entered.connect(_on_body_entered)
	
	# 2. Conectar animación y reproducir
	# Esto asegura que el código controle cuándo muere el objeto
	var sprite = $AnimatedSprite2D
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("default") # Asegúrate que tu animación se llame "default"

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_animation_finished():
	queue_free() # Elimina el ataque al terminar la animación
