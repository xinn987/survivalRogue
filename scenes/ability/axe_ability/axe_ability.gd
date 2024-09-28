extends Node2D

const SPINNING_TIME = 3
const SPINNING_COUNT = 2
const SPINNING_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var spinning_center: Node2D
var init_direction


func _ready():
	init_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.tween_method(
		do_spinning_tween.bind(spinning_center), 0.0, float(SPINNING_COUNT), SPINNING_TIME)
	tween.tween_callback(queue_free)
	

func do_spinning_tween(rotations: float, _spinning_center: Node2D):
	# 随机初始方向
	# 计算位置半径
	var total_percent = rotations / SPINNING_COUNT
	var radius = total_percent * SPINNING_RADIUS
	# 计算方向
	var spinning_direction = init_direction.rotated(rotations * TAU)
	
	global_position = _spinning_center.global_position + spinning_direction * radius
