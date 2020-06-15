extends "res://scripts/enemy.gd"


func _ready():
	Global.FireBlob = self
	damage = 10
	lives = 50
	speed = 50
	hitarea_position = 8.5
	
func randomize_wait_time():
	var my_wait_time= randi() % 5 + 1
	$PatrolTimer.wait_time = my_wait_time
