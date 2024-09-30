extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var floating_text_scene: PackedScene


func _ready():
	area_entered.connect(on_area_entered)
	

func display_floating_damage(damage: float):
	# 浮现伤害文本
	var floating_text = floating_text_scene.instantiate() as FloatingText
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(floating_text)
	floating_text.global_position = global_position + Vector2.UP * 16
	floating_text.display(str(damage))

	
func on_area_entered(other: Area2D):
	if not other is HitboxComponent:
		return
	
	if health_component == null:
		return
		
	var hitbox_component = other as HitboxComponent
	var damage_value = hitbox_component.damage
	health_component.damage(damage_value)
	
	display_floating_damage(damage_value)
