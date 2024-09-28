extends CharacterBody2D


const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 15

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar

var number_colliding_bodies = 0


func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_updated.connect(on_health_updated)
	update_health_display()


func _process(delta):
	var direction = get_movement_vector().normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	# 没有触碰敌人，不受到伤害
	# 碰撞计时器正在冷却，不受到伤害
	if number_colliding_bodies == 0 or !damage_interval_timer.is_stopped():
		return
	# 否则受到伤害，且碰撞计时器开始冷却
	damage_interval_timer.start()
	health_component.damage(1)
	
	print("current_health: " + str(health_component.current_health))
	
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()
	

func on_body_entered(other: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout(): 
	check_deal_damage()


func on_health_updated():
	update_health_display()
