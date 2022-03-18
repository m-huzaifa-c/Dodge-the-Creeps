extends Node

var Mob := preload("res://source/Scenes/Enemy.tscn")

onready var mob_timer   := get_node("MobTimer")
onready var score_timer := get_node("ScoreTimer")
onready var player      := get_node("Player")
onready var container   := get_node("container")
onready var hud         := get_node("HUD")
onready var particle_1  := get_node("particle/particle_1")
onready var particle_2  := get_node("particle/particle_2")

var score = 0
onready var x = $MobPath


func _ready():
	#__________________
	#480 x 720
	x = $MobPath
	change_path()
	
	
	#________________
	randomize()
	particle_1.emitting = true
	particle_2.emitting = true
func game_over():
	$music.stop()
	$game_over.play()
	mob_timer.stop()
	score_timer.stop()
	hud.show_game_over()
	particle_1.emitting = false
	particle_2.emitting = false
	get_tree().call_group("mob","queue_free")

func game_start():
	$music.play()
	particle_1.emitting = true
	particle_2.emitting = true
	score = 0
	$StartTimer.start()
	player.start($PlayerPosition.position)
	mob_timer.start()
	score_timer.start()

func _on_Player_hit():
	game_over()

func _on_ScoreTimer_timeout():
	score += 1
	if score > 15:
		mob_timer.wait_time = 0.5
		score_timer.wait_time = 2
	if score > 30:
		mob_timer.wait_time = 0.3
		score_timer.wait_time = 4
	hud.update_score(score)


func _on_MobTimer_timeout():
	
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	container.add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_HUD_start_game():
	score = 0
	hud.update_score(score)
	hud.show_messages("Get Ready!")
	yield($HUD/Message_timer,"timeout")
	game_start()
	
func change_path():
	x = $MobPath
	x.curve.set_point_position(0,Vector2(0,0))
	x.curve.set_point_position(1,Vector2(Utils.view_size.x,0))
	x.curve.set_point_position(2,Vector2(Utils.view_size.x,Utils.view_size.y))
	x.curve.set_point_position(3,Vector2(0,Utils.view_size.y))


func _on_ColorRect_resized():
	change_path()
