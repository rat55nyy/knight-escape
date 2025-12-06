extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var exp_bar = $ExpBar
@onready var label_nivel = $ExpBar/LabelNivel

func update_health(new_hp):
	health_bar.value = new_hp

func update_experience(current_xp, max_xp):
	exp_bar.max_value = max_xp
	exp_bar.value = current_xp

func update_level_text(new_level):
	label_nivel.text = "NIVEL: " + str(new_level)
