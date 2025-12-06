extends CharacterBody2D

var gem_scene = preload("res://scenes/experiencegem.tscn")

var speed = 100
var hp = 30  
var player = null


var damage = 10         
var attack_cooldown = 0.0 

@onready var anim = $AnimatedSprite2D 
@onready var hitbox = $Hitbox 


var variantes = ["orc", "ske", "sli"]
var variante_actual = "" 

func _ready():
	if variante_actual == "":
		variante_actual = variantes.pick_random()
	
	anim.play("walk_" + variante_actual)
	
	if variante_actual == "orc":
		hp = 50 
		speed = 80 

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		var dist = global_position.distance_to(player.global_position)
		

		if dist > 10.0:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
			
		move_and_slide()
		animate_enemy()
		
		check_damage(delta)

func check_damage(delta):
	if attack_cooldown > 0:
		attack_cooldown -= delta
		return


	var cuerpos = hitbox.get_overlapping_bodies()
	
	for body in cuerpos:
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
				attack_cooldown = 0.5
				break 

func animate_enemy():
	anim.play("walk_" + variante_actual)
	
	if player:
		var distancia_x = player.global_position.x - global_position.x
		
		if abs(distancia_x) > 10.0:
			if distancia_x < 0:
				anim.flip_h = true
			else:
				anim.flip_h = false

func take_damage(amount):
	hp -= amount
	modulate = Color(1, 0, 0) 
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	
	if hp <= 0:
		die()

func die():
	if gem_scene:
		var gem = gem_scene.instantiate()
		gem.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", gem)
	
	queue_free()
