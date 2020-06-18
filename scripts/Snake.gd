extends "res://scripts/enemy.gd"


func _ready():
	$TextureProgress.rect_position.x = self.position.x
	$TextureProgress.rect_position.y = self.position.y + 65
	id = "s"
	Global.Snake = self
	damage = Global.Snake_damage
	max_hp = 30
	lives = 30
	speed = 70
	hitarea_position = 10.8
	exp_points = 5
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
