extends CharacterBody2D

var speed = 100
var hp = 30  # Vida del enemigo
var player = null

@onready var anim = $AnimatedSprite2D 

# Lista de variantes
var variantes = ["orc", "ske", "sli"]
# Si esta variable se cambia desde fuera (Spawner), el enemigo respetará esa decisión
var variante_actual = "" 

func _ready():
	# LÓGICA DE HORDAS:
	# Si el Spawner no le dijo qué ser (está vacío), elige al azar.
	# Si ya tiene nombre (ej: "sli"), se salta esto y usa el que le dieron.
	if variante_actual == "":
		variante_actual = variantes.pick_random()
	
	anim.play("walk_" + variante_actual)
	
	# Ajustar vida según el tipo (Opcional, para equilibrar dificultad después)
	if variante_actual == "orc":
		hp = 50 # Los orcos son más duros
		speed = 80 # Y más lentos

func _physics_process(_delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		animate_enemy(direction)

func animate_enemy(direction):
	anim.play("walk_" + variante_actual)
	if direction.x < 0:
		anim.flip_h = true
	elif direction.x > 0:
		anim.flip_h = false

# ESTA ES LA FUNCIÓN NUEVA PARA RECIBIR DAÑO
func take_damage(amount):
	hp -= amount
	# Efecto visual simple: parpadeo rojo (modulate)
	modulate = Color(1, 0, 0) 
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	
	if hp <= 0:
		die()

func die():
	# Aquí podrías poner una animación de muerte o soltar experiencia
	queue_free() # Elimina al enemigo del juego
