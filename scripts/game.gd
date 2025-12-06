extends Node2D

var enemy_scene = preload("res://scenes/enemy.tscn")


@onready var player = $Player
@onready var hud = $HUD

func _ready():
	$EnemySpawnerTimer.timeout.connect(_on_enemy_spawner_timer_timeout)
	
	if player and hud:

		player.health_changed.connect(hud.update_health)
		player.experience_changed.connect(hud.update_experience)
		

		if player.has_signal("level_changed"):
			player.level_changed.connect(hud.update_level_text)
		

		hud.update_health(player.hp)
		hud.update_experience(player.experience, player.experience_required)
		hud.update_level_text(player.level)
		
	else:
		print("Error: No se encuentra el nodo Player o el nodo HUD en la escena.")

func _on_enemy_spawner_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var random_angle = randf() * TAU 
	var distance = randf_range(400, 600) 
	var spawn_pos = player.global_position + Vector2(cos(random_angle), sin(random_angle)) * distance
	
	enemy.global_position = spawn_pos
	add_child(enemy)
