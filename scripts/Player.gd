extends KinematicBody2D


const SPEED = 500
const JUMP_SPEED= -1200
const GRAVITY = 3600
const UP=Vector2(0,-1)
const JUMP_BOOST = 1.7*JUMP_SPEED

var motion = Vector2()
var has_double_jumped = false
#var flinch = false
#var boosted
var Double_Jump = false

export var world_limit= 3000
export var damage = 10
export var max_hp = 1000
var lives
export var level = 1
var exp_points = 0
export var max_exp = 250

var state_machine
var fighting = false

var purplegem_count = 0
var potion_count = 0
var coins_count = 0

var next_quest = false
var quest2 = false

var can_die = true


func _ready():
	Global.Player = self
	lives = max_hp
	state_machine = $AnimationTree.get("parameters/playback")

func _process(delta):
	if next_quest == true:
		next_quest()
	if exp_points >= max_exp:
		level_up()

func _physics_process(delta):
	fall(delta)
	fight()
	run()
	jump()
	move_and_slide(motion, UP)


#func _process(delta):
#	update_animation()


func fight():
	if Input.is_action_pressed("punch"):
		fighting = true
		state_machine.travel("attack1")
	elif Input.is_action_pressed("skill"):
		if level >= 2:
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
		$DamageArea.position.x = $CollisionShape2D.position.x
		state_machine.travel("run")
	else:
		$Sprite.set_flip_h(false)
		$Sprite/HitArea.position.x = 8
		$CollisionShape2D.position.x= -9
		$DamageArea.position.x = $CollisionShape2D.position.x
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
	#limiting the fall speed
	motion.y = clamp(motion.y, (JUMP_BOOST), -JUMP_SPEED)
	if is_on_floor():
		motion.y=0
	elif is_on_ceiling() :
		motion.y=+ 1
	else:
		motion.y += GRAVITY * delta
	#if position.y > world_limit:
		#Global.GameState.end_game()


#Being called by GameState
func hurt(enemy):
	if can_die:
	#$AnimatedSprite/Timer.start()
		state_machine.travel("hurt")
#	flinch = true
	#Global.Pain_SFX.play()
		motion.x = SPEED
		if enemy == Global.Snake:
			lives -= Global.Snake_damage
		else:
			lives-= Global.Fireblob_damage
	#print("PL", lives)
		if lives <= 0 :
			die()
	
func die():
	if can_die:
		can_die = false
		$DeathTimer.start()
		$SFX/Die_SFX.play()
		set_physics_process(false)
		$DamageArea/CollisionShape2D.disabled = true
		state_machine.travel("die")
	
#func when timer ends:
	#hurt = false
#func _on_Timer_timeout():
	#flinch = false
#	boosted = false



func _on_HitArea_area_entered(area):
	if area.is_in_group("hitable"):
		area.take_damage(self)

func purplegem_up():
	purplegem_count += 1
	get_parent().find_node("PurpleGems").set_item_text(0,str(purplegem_count))
	$SFX/Item_SFX.play()
#	print("gems count= ", purplegem_count)
func potion_up():
	potion_count += 1
	get_parent().find_node("FBBlood").set_item_text(0,str(potion_count))
	$SFX/Item_SFX.play()
#	print("potion count= ", potion_count)
func coins_up(amount):
	coins_count += amount
	$SFX/Item_SFX.play()
#	print("coins count= ", coins_count)
func exp_up(amount):
	exp_points += amount
#	print("exp points= ", exp_points)

# Being called by NPC1.gd ( _input(event) )
func next_quest():
	if Global.quest ==1 :
		get_parent().find_node("QuestProgress_Label").text = str( "Quest Progress: \n" ,  (10 - potion_count ), " <FireBlob's blood> \n to go." )
		get_parent().find_node("QuestProgress_Popup").show()
		if potion_count >= 10:
	#		print("@@@QUEST 1 COMPLETE!@@@")
			get_parent().find_node("QuestProgress_Popup").hide()
			get_parent().find_node("QC_Animation").play("show")
			next_quest =false
			$SFX/QuestComplete_SFX.play()
			Global.NPC1.quest_complete()
	elif Global.quest == 2:
		get_parent().find_node("QuestProgress_Label").text = str( "Quest Progress: \n",  (10 - purplegem_count ), " <Purple Gems> \n to go." )
		get_parent().find_node("QuestProgress_Popup").show()
		if purplegem_count >= 10:
	#		print("@@@QUEST 2 COMPLETE!@@@")
			get_parent().find_node("QuestProgress_Popup").hide()
			get_parent().find_node("QC_Animation").play("show")
			next_quest = false
			$SFX/QuestComplete_SFX.play()
			Global.NPC1.quest_complete()
		


func level_up():
	get_parent().find_node("LU_Animation").play("show")
	damage += 10
	level += 1
	print("level up! " , level)
#	get_parent().find_node("Level_Label").text = str("Level: ", level)
	print("damage = ", damage)
	exp_points -= max_exp
	max_exp = max_exp + (max_exp/10)
	$SFX/LevelUp_SFX.play()
	Global.GUI.update_GUI()



func _on_DeathTimer_timeout():
	lives = max_hp
	self.position.x = 300
	self.position.y = 700
	$SFX/Revive_SFX.play()
	$DamageArea/CollisionShape2D.disabled = false
	set_physics_process(true)
	state_machine.travel("idle")
	level = 1
	damage = 10
	exp_points = 0
	Global.GUI.update_GUI()
	can_die = true
