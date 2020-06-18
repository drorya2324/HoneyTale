extends Node
var GameState
var PlayerAnimations
var JumpPad
var Jump_SFX
var Coin_SFX
var Pain_SFX
var LifeUp_SFX
var JumpPad_SFX

var Game
var Player
var Snake
var FireBlob
var NPC1
var GUI

var quest = 1
var reward = 0
var QuestMessages = "res://JsonFiles/quest.json"
var RewardMessages = "res://JsonFiles/reward.json"

var Snake_scene = load("res://scenes/enemies/Snake.tscn")
var FireBlob_scene = load("res://scenes/enemies/FireBlob.tscn")

var Fireblob_damage = 10
var Snake_damage = 5


var purplegem_scene = load("res://scenes/enemies/Collectables/snake/purplegem.tscn")
var coin_scene = load("res://scenes/enemies/Collectables/Coin.tscn")
var potion_scene = load("res://scenes/enemies/Collectables/fireblob/Potion.tscn")
