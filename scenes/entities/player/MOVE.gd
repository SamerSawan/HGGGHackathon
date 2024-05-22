extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement(delta)
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y > 0:
		SignalBus.coyote_jump.emit()
		return STATES.FALL
	if Player.jump_input_actuation || Player.jump_buffer == true:
		return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	return null
func enter_state():
	Player.can_dash = true
