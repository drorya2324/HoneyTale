extends Node

onready var spawn_areas_count = get_node("SpawnArea").get_child_count()
var rnd = RandomNumberGenerator.new()
var enemies_count


func _ready():
	Global.Game = self
	spawn()
#	show_items()


func _on_SpawningTimer_timeout():
	check_enemies_count()
	
func spawn():
	var snake = Global.Snake_scene.instance()
	var fire_blob = Global.FireBlob_scene.instance()
	randomize()
	#for child in spawn_areas_count:
#	var current_area = get_node("SpawnArea").get_child(child)
	var current_area = get_node("SpawnArea/Area2D")
	var max_x =  8.8 #int(current_area.scale.x)
	var min_x = -8.3 #int(current_area.position.x - (max_x/2))
	var y = -70 #int(current_area.scale.y)
	var rand_x = rnd.randi_range(min_x,max_x)
	var current_enemy = randi() % 2
	if current_enemy == 0 :
		snake.position.x =  rand_x 
		snake.position.y =  y
		snake.scale.x = 0.1
		snake.scale.y = 5
		get_node("Enemies/Snakes").add_child(snake)
	else:
		fire_blob.position.x = rand_x
		fire_blob.position.y = y
		fire_blob.scale.x = 0.1
		fire_blob.scale.y = 5
		get_node("Enemies/FireBlobs").add_child(fire_blob)
	$SpawningTimer.start()


func check_enemies_count():
	enemies_count = get_node("Enemies/FireBlobs").get_child_count() + get_node("Enemies/Snakes").get_child_count()
	if  enemies_count < 10:
	#	print("CHILDREN COUNT:",enemies_count)
		spawn()
	else:
		$SpawningTimer.start()
	$SpawningTimer.start()


func spawning():
	var snake = Global.Snake_scene.instance()
	var posx = -0.5
	var posy = -95
	snake.position.x = posx
	snake.position.y = posy
	snake.scale.x = 0.1
	snake.scale.y = 5
	$Enemies/Snakes.add_child(snake)
	
	


func show_items():
	var purplegem = Global.purplegem_scene.instance()
	purplegem.position.x = 850
	purplegem.position.y = 300
	get_node("Collectables").add_child(purplegem)
	Global.PurpleGem.set_pos(purplegem.position)


# Being called by Enemy.gd( item_drop() )
func show_item(enemy_pos,enemy_id):
	enemy_pos.y +=50
	if enemy_id == "s":
		var purplegem = Global.purplegem_scene.instance()
		purplegem.position.x = enemy_pos.x
		purplegem.position.y = enemy_pos.y
		get_node("Collectables").add_child(purplegem)
		purplegem.animate(enemy_pos)
		var coin = Global.coin_scene.instance()
		coin.position.x = enemy_pos.x
		coin.position.y = enemy_pos.y
		get_node("Collectables").add_child(coin)
		coin.animate(enemy_pos)
	elif enemy_id == "fb":
		var potion = Global.potion_scene.instance()
		potion.position = enemy_pos
		get_node("Collectables").add_child(potion)
		potion.animate(enemy_pos)
