extends KinematicBody2D

var lives
var distance_to_target
var state_machine
onready var target = Global.Player
var can_attack = true
var state = 0
var speed
var motion = Vector2()
var damage
var hitarea_position
var items
var id


###
const JUMP_SPEED= -1200
const GRAVITY = 3600
const UP=Vector2(0,-1)
const JUMP_BOOST = 1.7*JUMP_SPEED
###


func _ready():
	distance_to_target = (self.global_position.x -  target.global_position.x )
	state_machine= $AnimationTree.get("parameters/playback")


func _process(delta):
	if state == 0:
		pass
	#look_at(Global.Player.position)
	#	state_machine.travel("idle")
	elif state ==1:
		face_target()
		chase()
		attack()
	fall(delta)
	distance_to_target = (self.global_position.x -  target.global_position.x )
	move_and_slide(motion,UP)




func fall(delta):	
	#limiting the fall speed and allowing bunny
	# to boost properly on the JumpPads:
	motion.y = clamp(motion.y, (JUMP_BOOST), -JUMP_SPEED)
	if is_on_floor():
		motion.y=0
	elif is_on_ceiling() :
		motion.y=+ 1
	else:
		motion.y += GRAVITY * delta


# Being called by DamageArea.gd (take_damage())
func hurt(enemy):
	state_machine.travel("hurt")
	lives -= Global.Player.damage
	#if state == 0:
	update_state()



func update_state():
	if lives <=0:
		state = 2
		die()
	else:
		state = 1


func face_target():
#	print(hitarea_position)
	if self.global_position>target.global_position:
		$Sprite.flip_h = true
		$DamageArea.position.x = 3
	#	$HitArea.position.x = -hitarea_position
	else:
		$Sprite.flip_h = false
		$DamageArea.position.x = -3
	#	$HitArea.position.x = hitarea_position


func chase():
	if abs(distance_to_target)>30:
		if $Sprite.flip_h == true:
			motion.x = -speed
		else:
			motion.x = speed
		#move_and_slide(motion,UP)
		state_machine.travel("run")
	else:
		motion.x = 0



func attack():
	if can_attack and abs(distance_to_target)<=40:
		state_machine.travel("attack")
		can_attack = false
	#	$Sprite/EHitArea/CollisionShape2D.disabled = false
		$AttackTimer.start()


func _on_AttackTimer_timeout():
	#$Sprite/EHitArea/CollisionShape2D.disabled = true
	can_attack = true
	chase()



		
func die():
	$DeathTimer.start()
	$DamageArea/CollisionShape2D.disabled = true
	state_machine.travel("die")
	item_drop()


func _on_DeathTimer_timeout():
	queue_free()


func _on_PatrolTimer_timeout():
	if state ==0:
		get_tree().call_group("enemies","randomize_wait_time")
		if abs(motion.x) <= 2:
			if $Sprite.flip_h == true:
				motion.x = -speed
			else:
				motion.x = speed
			state_machine.travel("run")
		else:
			motion.x =0
			state_machine.travel("idle")
			$Sprite.flip_h = !$Sprite.flip_h
			$DamageArea.position.x = -$DamageArea.position.x
			
	else:
		$PatrolTimer.stop()

func item_drop():
	var rnd = RandomNumberGenerator.new()
	var chances = rnd.randi_range(0,0)
	if chances == 0:
		Global.Game.show_item(self.global_position,self.id)
