extends CharacterBody2D

@export var speed = 150.0 
@export var magic_slash_scene: PackedScene 

@onready var anim = $AnimatedSprite2D 
@onready var attack_timer = $AttackTimer 

var hp = 100
var max_hp = 100

var experience = 0
var experience_required = 100 
var level = 1


var is_dead = false  

func _ready():
	if attack_timer:
		attack_timer.wait_time = 1.5 
		attack_timer.timeout.connect(_on_attack_timer_timeout)
		attack_timer.start()
	else:
		print("ERROR: Falta el nodo 'AttackTimer'")

func _physics_process(_delta):
	if is_dead:
		return 

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
		anim.play("run")
		

		if direction.x < 0:
			anim.flip_h = true
		elif direction.x > 0:
			anim.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		anim.play("idle")

	move_and_slide()

func _on_attack_timer_timeout():
	if not is_dead:
		shoot()

func shoot():
	if magic_slash_scene == null:
		print("Falta asignar la Magic Slash Scene en el Inspector")
		return
	
	var attack = magic_slash_scene.instantiate()
	attack.global_position = global_position
	get_parent().add_child(attack)


func take_damage(amount):
	if is_dead: return

	hp -= amount
	print("Auch! Vida restante: ", hp)
	
	modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)

	if hp <= 0:
		die()

func die():
	is_dead = true          
	velocity = Vector2.ZERO   
	
	print("Iniciando animación de muerte...")
	anim.play("death")      
	

	await anim.animation_finished
	
	print("GAME OVER")
	get_tree().paused = true


func gain_experience(amount):
	if is_dead: return

	experience += amount
	print("XP ganada: ", amount, " | Total: ", experience, "/", experience_required)
	
	if experience >= experience_required:
		level_up()

func level_up():
	level += 1
	experience -= experience_required
	experience_required += 50 
	
	print("¡SUBIDA DE NIVEL! Nivel actual: ", level)
	
	if attack_timer.wait_time > 0.5:
		attack_timer.wait_time -= 0.1
		print("¡Disparas más rápido!")
