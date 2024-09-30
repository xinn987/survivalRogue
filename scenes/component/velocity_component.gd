extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

var current_velocity: Vector2 = Vector2.ZERO
var current_owner: CharacterBody2D


func _ready():
	assert(owner != null and owner is CharacterBody2D, "error owner type")
	current_owner = owner


func move():
	update_velocity()
	current_owner.velocity = current_velocity
	current_owner.move_and_slide()
	current_velocity = current_owner.velocity


func update_velocity():
	var direction = get_direction_to_player()
	var target_velocity = direction * max_speed
	current_velocity = current_velocity.lerp(
		target_velocity, 1 - exp(- acceleration * get_process_delta_time()))
	

func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	return (player.global_position - current_owner.global_position).normalized()
	
