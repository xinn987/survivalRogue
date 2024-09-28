extends Node

@export var axe_ability_scene: PackedScene

@onready var timer = $Timer

var damage = 10
var spawn_interval_time = 3.5

func _ready():
	timer.timeout.connect(on_timer_timeout)	
	timer.wait_time = spawn_interval_time
	timer.start()
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	var axe_ability_instance = axe_ability_scene.instantiate() as Node2D
	axe_ability_instance.spinning_center = player
	foreground_layer.add_child(axe_ability_instance)
	axe_ability_instance.hitbox_component.damage = damage
	
