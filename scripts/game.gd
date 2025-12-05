extends Node2D

# Cargamos la escena del enemigo para poder clonarla
var enemy_scene = preload("res://scenes/enemy.tscn")

func _ready():
	# Conectamos el timer del spawner
	$EnemySpawnerTimer.timeout.connect(_on_enemy_spawner_timer_timeout)

func _on_enemy_spawner_timer_timeout():
	# 1. Crear la copia del enemigo
	var enemy = enemy_scene.instantiate()
	
	# 2. Calcular una posición aleatoria alrededor del jugador
	# Obtenemos la referencia al jugador (asumiendo que se llama "Player" en la escena)
	var player = $Player 
	
	# Creamos un punto aleatorio en un círculo a 500 pixeles de distancia
	var random_angle = randf() * TAU # Un ángulo aleatorio (0 a 360 grados)
	var distance = randf_range(400, 600) # Distancia entre 400 y 600 pixeles
	
	# Calculamos la posición final
	var spawn_pos = player.global_position + Vector2(cos(random_angle), sin(random_angle)) * distance
	
	# 3. Asignar la posición y añadirlo al juego
	enemy.global_position = spawn_pos
	add_child(enemy)
