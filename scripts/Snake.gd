extends "res://scripts/enemy.gd"


func _ready():
	#$Sprite/HitArea/CollisionShape2D.disabled = true
	Global.Snake = self
	damage = 5
	lives = 30
	speed = 70
	hitarea_position = 10.8
	
func randomize_wait_time():
	var my_wait_time= randi() % 5 + 1
	$PatrolTimer.wait_time = my_wait_time


func _on_HitArea_area_entered(area):
	if area.is_in_group("hitable"):
		area.take_damage(self)
	else:
		print("ng",area)
