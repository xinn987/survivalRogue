extends Node


signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const INIT_TARGET_EXPERIENCE = 2
const TARGET_EXPERIENCE_GROWTH = 2

var current_experience = 0
var current_level = 1
var target_experience


func _ready():
	target_experience = INIT_TARGET_EXPERIENCE
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(number: float):
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience, target_experience)
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)
		
		print("升级! 当前等级为 " + str(current_level))


func on_experience_vial_collected(number: float):
	increment_experience(number)
