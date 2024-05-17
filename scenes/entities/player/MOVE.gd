extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y >0:
		return STATES.FALL
	
	if Player.jump_input_actuation:
		return STATES.JUMP
	return null
