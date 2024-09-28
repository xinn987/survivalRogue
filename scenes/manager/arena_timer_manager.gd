extends Node

signal difficulty_updated(current_difficulty: int)

const INIT_ARENA_TIME = 300
const DIFFICULTY_GROWTH_TIME_SLOT = 5

@export var end_screen_scene: PackedScene
@onready var arena_timer = $ArenaTimer

var current_difficulty = 0


func _ready():
	arena_timer.wait_time = INIT_ARENA_TIME
	arena_timer.start()
	arena_timer.timeout.connect(on_timeout)


func _process(delta):
	var elapsed_time = get_time_elapsed()
	var time_threshold = (current_difficulty + 1) * DIFFICULTY_GROWTH_TIME_SLOT
	if elapsed_time > time_threshold:
		current_difficulty += 1
		difficulty_updated.emit(current_difficulty)


func get_time_elapsed():
	return arena_timer.wait_time - arena_timer.time_left


func on_timeout():
	if end_screen_scene == null:
		return
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_victory()
