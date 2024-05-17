extends Node



var STATES = null
var Player = null

func enter_state():
	pass

func exit_state():
	pass
	
func update(delta):
	return null

func player_movement():
	if Player.movement_input.x > 0:
		Player.velocity.x = Player.SPEED
	elif Player.movement_input.x < 0:
		Player.velocity.x = -Player.SPEED
	else: 
		Player.velocity.x = 0
