extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene

var damage = 5
var base_wait_time


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(ability_upgrade_added)
	
	base_wait_time = $Timer.wait_time


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
		
	# 排序选择距离玩家最近的敌人
	enemies.sort_custom(func(a: Node2D, b: Node2D): 
		var a_dist = a.global_position.distance_squared_to(player.global_position)
		var b_dist = b.global_position.distance_squared_to(player.global_position)
		return a_dist < b_dist
	)
	var target_enemy = enemies[0] as Node2D
	
	# 实例化
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.global_position = target_enemy.global_position
	sword_instance.hitbox_component.damage = damage
	
	# 调整实例方向
	var sword_direction = player.global_position - target_enemy.global_position
	sword_instance.rotation = sword_direction.angle()
	

func ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return
	var upgrade_quantity = current_upgrades["sword_rate"]["quantity"]
	$Timer.wait_time = base_wait_time * max(1 - upgrade_quantity * 0.1, 0.1)
	$Timer.start()
	print($Timer.wait_time)
	
	
	
	
