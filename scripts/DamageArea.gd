extends Area2D


 #Being called by Player.gd(_on_HitArea_area_entered(area))
func take_damage(enemy):
	get_parent().hurt(enemy)
