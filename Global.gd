extends Node
var GameState
var Game
var Player
var GUI
var PlayerAnimations
var JumpPad
var Jump_SFX
var Coin_SFX
var Pain_SFX
var LifeUp_SFX
var JumpPad_SFX

var Snake
var FireBlob


var Snake_scene = load("res://scenes/enemies/Snake.tscn")
var FireBlob_scene = load("res://scenes/enemies/FireBlob.tscn")


var purplegem_scene = load("res://scenes/enemies/Collectables/snake/purplegem.tscn")
var coin_scene = load("res://scenes/enemies/Collectables/Coin.tscn")
var potion_scene = load("res://scenes/enemies/Collectables/fireblob/Potion.tscn")
