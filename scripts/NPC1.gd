extends KinematicBody2D


var distance_from_player
var players_story
var my_story
var can_dialog = false

var quest
var reward
var quest_complete = false
var reward_complete = false
var dialoged = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.NPC1 = self
	quest = get_quest_from_json()
	reward = get_reward_from_json()
	$Dialog/Popup.hide()
	#my_story = self.global_position.y
	#distance_from_player = abs(self.global_position.x - Global.Player.global_position.x)

#func _process(delta):
	#distance_from_player = abs(self.global_position.x - Global.Player.global_position.x)
	#players_story = Global.Player.position.y

func get_quest_from_json():
	var file = File.new()
	file.open(Global.QuestMessages,File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)

func get_reward_from_json():
	var file = File.new()
	file.open(Global.RewardMessages,File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)



func _on_ClickArea_body_entered(body):
	if body.collision_layer == 1:
	#	print("body entered")
		can_dialog = true
		

func _input(event):
	if can_dialog and Input.is_action_just_pressed("ui_accept"):
		dialoged = true
		if reward_complete or Global.quest == 1:
			update_quest_text()
		#	Global.Player.next_quest()
		if quest_complete:
#			print("update reward text")
			update_reward_text()
			Global.Player.coins_up(50)
			Global.Player.exp_up(50)
			reward_complete()
			quest_complete = false
		
		
	#	if distance_from_player <= 180 and (players_story-120) < my_story:
		$Dialog/Popup.show()
		#update_quest_text()
#		print("dialog")



func update_quest_text():
	$Dialog/Popup/Label.text = quest[str(Global.quest)]


# Being called by Player.gd ( next_quest() )
func quest_complete():
	if Global.reward <2:
		Global.reward += 1
		$Reward_SFX.play()
	#	print("reward = " , Global.reward)
		quest_complete = true


func _on_ClickArea_body_exited(body):
	# $dialog/popup.hide()
	if body.collision_layer == 1:
	#	print("body exited")
		if dialoged:
			$Dialog/Popup.hide()
			if reward_complete or Global.quest == 1:
				Global.Player.next_quest = true
				reward_complete = false
			dialoged = false

		#if Global.quest == 1:
		#	Global.Player.quest1 = true
		#elif Global.quest == 2:
		#	Global.Player.quest2 = true
		#can_dialog = false
		


func update_reward_text():
	$Dialog/Popup/Label.text = reward[str(Global.reward)]

func reward_complete():
	if Global.quest <2:
		Global.quest += 1
		print("quest = ", Global.quest)
		reward_complete = true
