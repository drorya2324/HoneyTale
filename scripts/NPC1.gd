extends KinematicBody2D


var distance_from_player
var players_story
var my_story

# Called when the node enters the scene tree for the first time.
func _ready():
	my_story = self.global_position.y
	distance_from_player = abs(self.global_position.x - Global.Player.global_position.x)
	print("ms: " ,my_story)

func _process(delta):
	distance_from_player = abs(self.global_position.x - Global.Player.global_position.x)
	players_story = Global.Player.position.y
	
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print("dfp: ",distance_from_player)
		print("ps: ",players_story-120)
		if distance_from_player <= 180 and (players_story-120) < my_story:
			print("dialog")

