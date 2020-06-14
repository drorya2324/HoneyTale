extends AnimationTree

var state_machine


func _ready():
	state_machine = get("parameters/playback")
	print(state_machine)
	Global.PlayerAnimations = self
	
#Being called by Player (update_motion())
func updating(motion):
	var current = state_machine.get_current_node()
	if motion.length() == 0:
		state_machine.travel("idle")
	if motion.x !=0 :
		state_machine.travel("run")
	
	
#	if  motion.x>1:
#		set_flip_h(false)
#		play("run")
#	elif motion.x < 0:
#		set_flip_h(true)
#		play("run")
#	else:
#		if motion == Vector2(0,0):
#			play("idle")
#		else:
#			play("jump")
#	if Input.is_action_just_pressed("ui_up"):
#		play("jump")
#	if Global.Player.flinch == true:
#		play("hurt")
#	check_input(motion)


#func fight():
#func check_input(motion):
	# "punch" key: 'Z', "skill" key: 'X'
#	if Input.is_action_just_pressed("punch"):
#		motion.x = 1
#		$ActionTimer.start()
#		play("punch")
#		if Input.is_action_just_pressed("punch"):
#			play("punch2")
#	elif Input.is_action_just_pressed("skill"):
#		motion.x =1
#		play("skill")
#		$ActionTimer.start()
		

func hurt():
	state_machine.travel("hurt")
func die():
	state_machine.travel("die")


#func _on_ActionTimer_timeout():
#	play("idle")

