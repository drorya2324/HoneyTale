extends Node2D

onready var Player = Global.Player

func _ready():
	Global.GUI = self
	$CanvasLayer/PlayerProgress/VBoxContainer/HP_Container2/HP_Progress.max_value = Player.max_hp
	$CanvasLayer/PlayerProgress/VBoxContainer/EXP_Container/EXP_Progress.max_value = Player.max_exp



func _process(delta):
	$CanvasLayer/PlayerProgress/VBoxContainer/HP_Container2/HP_Progress.value = Player.lives
	$CanvasLayer/PlayerProgress/VBoxContainer/EXP_Container/EXP_Progress.value = Player.exp_points
	
func update_GUI():
	print("updating GUI")
	$CanvasLayer/PlayerProgress/VBoxContainer/HP_Container2/HP_Progress.max_value = Player.max_hp
	$CanvasLayer/PlayerProgress/VBoxContainer/EXP_Container/EXP_Progress.max_value = Player.max_exp
	$CanvasLayer/PlayerProgress/VBoxContainer/Level_Label.text = str("Level: ", Global.Player.level)


