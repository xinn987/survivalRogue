extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

# 单次升级可选择的选项数量
var upgrade_pick_cnt = 2
# 当前升级信息
var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)

	
func apply_upgrade(upgrade: AbilityUpgrade):
	if !current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		# 从升级池中去除达到上限的升级项
		if current_upgrades[upgrade.id]["quantity"] >= upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func(u): return upgrade.id != u.id)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	print("当前技能升级信息: "+ str(current_upgrades))
	

# 在升级池中不重复随机选择n个
func pick_upgrades():
	var result: Array[AbilityUpgrade] = []
	var indexes = range(upgrade_pool.size())
	indexes.shuffle()
	var picked_indexes = indexes.slice(0, upgrade_pick_cnt)
	
	for i in picked_indexes:
		result.append(upgrade_pool[i])
	return result


func on_level_up(current_level: int):
	var chosen_upgrades: Array[AbilityUpgrade] = pick_upgrades()
	if chosen_upgrades.is_empty():
		return
	var upgrade_screen = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen)
	upgrade_screen.set_upgrades(chosen_upgrades)
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


