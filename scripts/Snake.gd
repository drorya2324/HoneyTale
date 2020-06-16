extends "res://scripts/enemy.gd"


func _ready():
	id = "s"
	Global.Snake = self
	damage = 5
	lives = 30
	speed = 70
	hitarea_position = 10.8
#	items = 


func _process(delta):
	if $Sprite.flip_h == true:
		$Sprite/HitArea.position.x = -9
	else:
		$Sprite/HitArea.position.x = 9

func randomize_wait_time():
	var my_wait_time= randi() % 5 + 1
	$PatrolTimer.wait_time = my_wait_time


func _on_HitArea_area_entered(area):
	if area.is_in_group("hitable"):
		area.take_damage(self)
