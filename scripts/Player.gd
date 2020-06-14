extends KinematicBody2D
const SPEED = 500
const JUMP_SPEED= -1200
const GRAVITY = 3600
const UP=Vector2(0,-1)
const JUMP_BOOST = 1.7*JUMP_SPEED

var motion = Vector2()
var has_double_jumped = false
var flinch = false
var boosted
var Double_Jump = false

export var world_limit= 3000
export var damage = 10

var state_machine
var fighting = false

func _ready():
	Global.Player = self
	state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	fall(delta)
	fight()
	run()
	jump()
	move_and_slide(motion, UP)


#func _process(delta):
#	update_animation()


func fight():
	if Input.is_action_just_pressed("punch"):
		fighting = true
		state_machine.travel("attack1")
	elif Input.is_action_just_pressed("skill"):
		fighting = true
		state_machine.travel("attack2")

func update_animation():
	Global.PlayerAnimations.updating(motion)
	#Global.PlayerAnimations.fight()


func run():
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") :
		motion.x = -SPEED
		flip(true)
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") :
		motion.x = SPEED
		flip(false)
	else:
		if is_on_floor():
			motion.x =  0
			if not fighting:
				state_machine.travel("idle")

func flip(booli):
	if booli:
		$Sprite.set_flip_h(true)
		$Sprite/HitArea.position.x = -8
		$CollisionShape2D.position.x= 9
		state_machine.travel("run")
	else:
		$Sprite.set_flip_h(false)
		$Sprite/HitArea.position.x = 8
		$CollisionShape2D.position.x= -9
		state_machine.travel("run")
	fighting = false


func jump():
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor() == true:
			has_double_jumped = false
			motion.y =  JUMP_SPEED
			state_machine.travel("jump")
	#		Global.Jump_SFX.play()
		elif has_double_jumped == false:
			motion.y =  JUMP_SPEED/1.3
			state_machine.travel("jump")
	#		Global.Jump_SFX.play()
			has_double_jumped = true


func fall(delta):	
	#limiting the fall speed and allowing bunny
	# to boost properly on the JumpPads:
	motion.y = clamp(motion.y, (JUMP_BOOST), -JUMP_SPEED)
	if is_on_floor() and not flinch and not boosted:
		motion.y=0
	elif is_on_ceiling() :
		motion.y=+ 1
	else:
		motion.y += GRAVITY * delta
	#if position.y > world_limit:
		#Global.GameState.end_game()


#Being called by GameState
func hurt():
	$AnimatedSprite/Timer.start()
	state_machine.travel("hurt")
	flinch = true
	#Global.Pain_SFX.play()
	motion.y = JUMP_SPEED
func die():
	set_physics_process(false)
	
#func when timer ends:
	#hurt = false
func _on_Timer_timeout():
	flinch = false
	boosted = false



func _on_HitArea_area_entered(area):
	if area.is_in_group("hitable"):
		area.take_damage()
	else:
		print("ng",area)
