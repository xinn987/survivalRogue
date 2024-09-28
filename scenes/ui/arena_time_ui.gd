extends CanvasLayer


@export var arena_timer_manager: Node
@onready var label = $MarginContainer/Label

func _process(delta):
	if arena_timer_manager == null:
		return
	var time_elapsed = arena_timer_manager.get_time_elapsed()
	label.text = format_seconds(time_elapsed)


func format_seconds(seconds: float):
	var minutes = floor(seconds / 60)
	var remain_seconds = floor(seconds - minutes * 60)
	return str(minutes) + ":" + ("%02d" % remain_seconds)
