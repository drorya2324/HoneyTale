extends KinematicBody2D

var lives
var distance_to_target
var state_machine
onready var target = Global.Player
var can_attack = true
var state = 0
var speed
var motion = Vector2()


func _ready():
	state_machine= $AnimationTree.get("parameters/playback")

func _process(delta):
	if state != 2:
	#look_at(Global.Player.position)
		state_machine.travel("idle")
		distance_to_target = self.global_position.x -  target.global_position.x 
		flip()
	if state == 1:
		chase()
		attack()



func flip():
	if self.global_position>target.global_position:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false


func hurt():
	state_machine.travel("hurt")
	lives -= Global.Player.damage
	update_state()
	print(lives)


func _on_AttackTimer_timeout():
		can_attack = true

func chase():
	if abs(distance_to_target)>1:
		if $Sprite.flip_h == true:
			motion.x = -speed
		else:
			motion.x = speed
		move_and_slide(motion,Vector2(0,1))


func attack():
	if abs(distance_to_target) <=50 and can_attack:
		state_machine.travel("attack")
		can_attack = false
		$AttackTimer.start()



func update_state():
	if lives <=0:
		state = 2
		die()
	else:
		state = 1
		
func die():
	$DeathTimer.start()
	$DamageArea/CollisionShape2D.disabled = true
	state_machine.travel("die")


func _on_DeathTimer_timeout():
	queue_free()
