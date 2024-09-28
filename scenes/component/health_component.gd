extends Node
class_name HealthComponent


signal died
signal health_updated

@export var max_health: float = 10
var current_health: float


func _ready():
	current_health = max_health
	

func damage(damage_value: float):
	current_health = max(current_health - damage_value, 0)
	health_updated.emit()
	Callable(check_death).call_deferred()
	
	
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
	
	
func check_death():
	if current_health <= 0:
		died.emit()
		owner.queue_free()
