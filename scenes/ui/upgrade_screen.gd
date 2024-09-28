extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var ability_upgrade_card: PackedScene

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer


func _ready():
	get_tree().paused = true


func set_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = ability_upgrade_card.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_upgrade(upgrade)
		card_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
