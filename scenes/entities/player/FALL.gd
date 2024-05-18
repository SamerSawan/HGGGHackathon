extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	return null
