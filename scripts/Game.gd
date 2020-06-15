extends Node

onready var spawn_areas_count = get_node("SpawnArea").get_child_count()

#func _ready():
#	spawn()


#func _on_SpawningTimer_timeout():
#	check_enemies_count()
	
func spawn():
	var snake = Global.Snake_scene.instance()
	var fire_blob = Global.FireBlob_scene.instance()
	randomize()
	for child in spawn_areas_count:
		var current_child = get_node("SpawnArea").get_child(child)
		var max_x = int(current_child.scale.x)
		var min_x = int(current_child.position.x - (max_x/2))
		var max_y = int(current_child.scale.y)
		var min_y = int(current_child.position.y - (max_y/2))
		var rand_x = randi () % max_x + min_x
		var rand_y = randi () % max_y + min_y
		print(rand_x," , ",rand_y)
		var current_enemy = randi() % 2
		if current_enemy == 0 :
			snake.position.x =  rand_x 
			snake.position.y =  rand_y
			snake.scale.x = 0.1
			snake.scale.y = 5
			get_node("Enemies/Snakes").add_child(snake)
			print ("spawned snake at:", snake.position)
		else:
			fire_blob.position.x = rand_x
			fire_blob.position.y = rand_y
			fire_blob.scale.x = 0.1
			fire_blob.scale.y = 5
			get_node("Enemies/FireBlobs").add_child(fire_blob)
			print ("spawned fireblob at:", fire_blob.position)
	$SpawningTimer.start()


func check_enemies_count():
	var enemies_count = get_node("Enemies/FireBlobs").get_child_count() + get_node("Enemies/Snakes").get_child_count()
	if  enemies_count < 10:
		print("CHILDREN COUNT:",enemies_count)
		spawn()
	else:
		$SpawningTimer.start()
