extends PanelContainer
class_name AbilityUpgradeCard

signal upgrade_selected(upgrade: AbilityUpgrade)

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel

var current_upgrade: AbilityUpgrade


func _ready():
	gui_input.connect(on_gui_input)


func set_upgrade(upgrade: AbilityUpgrade):
	current_upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		upgrade_selected.emit(current_upgrade)
