extends Node2D

@export_file var next_level
@export var is_spawn_point: bool = false
@export var cave_id: int = 1
var area_active = false
var Player

func _input(event):
	if area_active and event.is_action_pressed("ui_accept"):
		on_door_interact()

func _on_area_entered(_area):
	area_active = true

func _on_area_exited(_area):
	area_active = false


func _ready():
	pass
#	SignalBus.deathzone.connect(respawn)
#	if is_spawn_point:
#		Player = get_tree().get_first_node_in_group("player")
#		Player.global_position = global_position

func on_door_interact():
	if next_level != null:
		AudioPlayer.cave_id = cave_id
		get_tree().change_scene_to_file(next_level)
	else:
		pass


