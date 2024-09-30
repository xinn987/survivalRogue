extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


func _process(delta):
	velocity_component.move()
	
	if velocity.x != 0:
		visuals.scale = Vector2(sign(velocity.x), 1)
