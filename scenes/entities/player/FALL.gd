extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement(delta)
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
	return null
