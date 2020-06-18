extends "res://scripts/enemy.gd"


func _ready():
	$TextureProgress.rect_position.x = self.position.x -6.5
	$TextureProgress.rect_position.y = self.position.y + 75
	id = "fb"
	Global.FireBlob = self
	damage = Global.Fireblob_damage
	max_hp = 50
	lives = 50
	speed = 50
	hitarea_position = 8.5
	exp_points = 10


func _process(delta):
	if $Sprite.flip_h == true:
		$Sprite/HitArea.position.x = -10
	else:
		$Sprite/HitArea.position.x = 10

func randomize_wait_time():
	var my_wait_time= randi() % 5 + 1
	$PatrolTimer.wait_time = my_wait_time


func _on_HitArea_area_entered(area):
	if area.is_in_group("hitable"):
		area.take_damage(self)
