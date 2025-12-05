extends CharacterBody2D

@export var speed = 150.0 
# Arrastra tu escena MagicSlash.tscn aquí en el Inspector
@export var magic_slash_scene: PackedScene 

@onready var anim = $AnimatedSprite2D 
@onready var attack_timer = $AttackTimer 

func _ready():
	if attack_timer:
		attack_timer.wait_time = 1.5 
		attack_timer.timeout.connect(_on_attack_timer_timeout)
		attack_timer.start()
	else:
		print("ERROR: Falta el nodo 'AttackTimer'")

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
		anim.play("run")
		
		# Voltear sprite del jugador
		if direction.x < 0:
			anim.flip_h = true
		elif direction.x > 0:
			anim.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		anim.play("idle")

	move_and_slide()

func _on_attack_timer_timeout():
	shoot()

func shoot():
	# Verificación de seguridad
	if magic_slash_scene == null:
		print("Falta asignar la Magic Slash Scene en el Inspector")
		return
	
	# Crear una instancia del ataque
	var attack = magic_slash_scene.instantiate()
	
	# Colocar el ataque en la posición exacta del jugador
	attack.global_position = global_position
	
	# ELIMINADO: attack.rotation = ... 
	# Al no rotarlo, siempre saldrá 'derecho' (como se ve en la escena original)
	
	# Añadir el ataque al mundo
	get_parent().add_child(attack)
