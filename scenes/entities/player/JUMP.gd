extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.velocity.y > 0:
		return STATES.FALL
	
	return null

func enter_state():
	Player.velocity.y = Player.JUMP_VELOCITY
