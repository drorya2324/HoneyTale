extends Area2D

onready var collectable = false

# Being called by Game.gd ( show_item(enemy_pos,enemy_id) )
func animate(posi):
	var pos
	pos = posi
	var pos2y = pos.y -10
	var pos2 = Vector2(pos.x,pos2y)
	$AnimationPlayer.get_animation("idle").track_set_key_value(0,0,pos)
	$AnimationPlayer.get_animation("idle").track_set_key_value(0,1,pos2)
	

#func set_pos(posi,inst):
#	inst.pos = posi
#	inst.animate()



func _on_Coin_body_entered(body):
	if body.collision_layer == 1 and collectable:
		Global.Player.coins_up(1)
		queue_free()
		#animate "magnet"
		#queue_free()



func _on_CollectableTimer_timeout():
	collectable= true
