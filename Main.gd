extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_game():
	$Music.play()
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$Music.stop()


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	# Declare new instance of Mob
	var mob = mob_scene.instantiate()
	
	# Pick a random point on the pre-defined spawn path
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Find line perpendicular to the path (always faces inwards to the screen)
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set spawn position
	mob.position = mob_spawn_location.position
	
	# Adds some variance to the Mob movement path (so it's not always straight lines)
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Define speed vector, since only one direction is set magnitude is equal to the generated val
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	# Rotate vector to face chosen direction
	mob.linear_velocity = velocity.rotated(direction)
	
	# Add mob to this scene
	add_child(mob)
