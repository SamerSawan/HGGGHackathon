extends Node2D

@export var is_final_level: bool = false

var Player
func _ready():
	Player = get_tree().get_first_node_in_group("player")
#	respawn()
	Player.global_position = get_node('CaveDoor' + str(AudioPlayer.cave_id)).global_position
	SignalBus.deathzone.connect(respawn)

func respawn():
	Player.global_position = get_tree().get_first_node_in_group("doors").global_position
	Player.respawn_anim()
