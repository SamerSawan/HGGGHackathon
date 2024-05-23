extends Node2D

var Player
var perception
var transparency = 1
var transparency2 = 0.2

func _ready():
	Player = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	self.modulate = Color(1,1,1,transparency)
	transparency = 1/(0.2 * (Player.perception))
