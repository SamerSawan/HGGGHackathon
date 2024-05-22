extends "state.gd"


func update(delta):
	Player.gravity(delta)
	player_movement(delta)
	jump_buffer()
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
	if Player.coyote_jump and Input.is_action_just_pressed("Jump"):
		return STATES.JUMP
	return null

func jump_buffer():
	if Input.is_action_pressed("Jump"):
		SignalBus.emit_signal("jump_buffer")

