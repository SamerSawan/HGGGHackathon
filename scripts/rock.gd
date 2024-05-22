extends Node2D

@onready var raycast = $RayCast2D
@export var Rock_speed = Vector2(50,-50)

var anim_start_time #or else it will crash on reset


func _ready():
	SignalBus.player_died.connect(reset)
	
func _process(delta):
	global_position.x += Rock_speed.x*delta
	global_position.y -= Rock_speed.y*delta
	delete()

func _on_area_2d_body_entered(body):
	if body.name == "Player": #signal received in cave_door script
		SignalBus.emit_signal("deathzone")
		reset()

func delete():
	if raycast.is_colliding():
		queue_free()

func reset():
	queue_free()
