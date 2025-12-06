extends Node2D


var enemy_scene = preload("res://scenes/enemy.tscn")

func _ready():
	$EnemySpawnerTimer.timeout.connect(_on_enemy_spawner_timer_timeout)

func _on_enemy_spawner_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var player = $Player 
	
	var random_angle = randf() * TAU 
	var distance = randf_range(400, 600) 
	
	var spawn_pos = player.global_position + Vector2(cos(random_angle), sin(random_angle)) * distance
	
	enemy.global_position = spawn_pos
	add_child(enemy)
