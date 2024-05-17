extends "state.gd"

func update(delta):
	Player.gravity(delta)
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.jump_input_actuation == true:
		return STATES.JUMP
	if Player.velocity.y >0:
		return STATES.FALL
	
	return null

func enter_state():
	pass


