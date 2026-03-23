# world_timer.gd
extends Timer
class_name WorldTimer

# On Start
func _ready():
	GameManager.set_world_timer(self)
