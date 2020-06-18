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


func _on_Potion_body_entered(body):
	if body.collision_layer == 1:
		collectable = true
		#animate "magnet"
		#queue_free()

func _input(event):
	if Input.is_action_just_pressed("collect_items") and collectable:
		Global.Player.potion_up()
		queue_free()
		


func _on_Potion_body_exited(body):
	if body.collision_layer == 1:
		collectable = false
