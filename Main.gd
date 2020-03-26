extends Node

export (PackedScene) var Mob

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BGM.stop()
	$HUD.show_game_over()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPos.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready...")
	$BGM.play()


func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = ($MobPath/MobSpawnLocation.rotation + PI/2) + rand_range(-PI/4, PI/4)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(mob.rotation)
	$HUD.connect("start_game", mob, "_on_start_game")


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
