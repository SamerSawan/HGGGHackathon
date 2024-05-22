extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement(delta)
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
	return null
	
func enter_state():
	Player.jump_buffer = false
	Player.velocity.y = Player.JUMP_VELOCITY
