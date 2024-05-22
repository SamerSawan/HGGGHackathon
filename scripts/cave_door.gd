extends Node2D

@export var next_level: PackedScene = null
@export var is_spawn_point: bool = false

var area_active = false
var Player

func _input(event):
	if area_active and event.is_action_pressed("ui_accept"):
		SignalBus.emit_signal("change_scene")

func _on_area_entered(area):
	area_active = true

func _on_area_exited(area):
	area_active = false


func _ready():
	SignalBus.change_scene.connect(on_door_interact)
	SignalBus.deathzone.connect(respawn)
	if is_spawn_point:
		Player = get_tree().get_first_node_in_group("player")
		Player.global_position = global_position

func on_door_interact():
	if next_level != null:
		get_tree().change_scene_to_packed(next_level)
	else:
		pass

func respawn():
	if is_spawn_point:
		Player.global_position = global_position
		Player.respawn_anim()
