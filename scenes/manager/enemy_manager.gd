extends Node

const SPAWN_RADIUS = 375
const INIT_SPWAN_INTERVAL_TIME = 1
const DIFFICULTY_SPWAN_INTERVAL_TIME_OFFSET = 0.01

@export var basic_enemy_scene: PackedScene
@export var arena_timer_manager: Node

@onready var timer = $Timer


func _ready():
	timer.wait_time = INIT_SPWAN_INTERVAL_TIME
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	arena_timer_manager.difficulty_updated.connect(on_difficulty_updated)


func get_spawn_position(player: Node2D):
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = Vector2.ZERO
	
	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS
		
		var query_param = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var query_result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_param)
		
		if query_result.is_empty():
			# 没有地形碰撞，可以生成
			break
		else:
			# 地形碰撞，重新生成
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return spawn_position


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var spawn_position = get_spawn_position(player)
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	var enemy_instance = basic_enemy_scene.instantiate() as Node2D
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = spawn_position


func on_difficulty_updated(current_difficulty: int):
	var time_offset = current_difficulty * DIFFICULTY_SPWAN_INTERVAL_TIME_OFFSET
	timer.wait_time = INIT_SPWAN_INTERVAL_TIME - min(time_offset, 0.9)
	print("敌人生成时间更新: " + str(timer.wait_time))
	
