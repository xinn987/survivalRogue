extends CanvasLayer

@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton


func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func set_victory():
	title_label.text = "胜利"
	description_label.text = "你赢了！"
	

func set_defeat():
	title_label.text = "失败"
	description_label.text = "胜败乃兵家常事"


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_quit_button_pressed():
	get_tree().quit()
