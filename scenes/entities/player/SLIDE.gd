extends "state.gd"


@export var climb_speed = 80
@export var slide_friction = .7

func update(delta):
	slide_movement(delta)
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Input.is_action_just_pressed("Jump") and Player.climbs > 0 and Input.is_action_pressed("MoveUp"): #allows jumping up walls
		Player.climbs -= 1
		return STATES.JUMP
	if Player.is_on_floor():
		return STATES.IDLE
	return null

func slide_movement(delta):
	if Input.is_action_just_pressed("Jump") && !Input.is_action_pressed("MoveUp"): #wall jump here cause uhhh idk lol
		if Player.get_next_to_wall() != null: #extra step but prevents crash that happens if u get off wall right before
			Player.velocity.x -= 675*Player.get_next_to_wall().x #wall jumping
			Player.velocity.y = Player.JUMP_VELOCITY
	else:
		pass
		
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = -climb_speed
		else:
			Player.velocity.y = 0
	else:
		player_movement(delta)
		Player.gravity(delta)
		
		if Player.velocity.y > 0: #only 'slide' when going down, not up
			Player.velocity.y *= slide_friction
