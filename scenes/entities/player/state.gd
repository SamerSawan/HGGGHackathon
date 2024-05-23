extends Node



var STATES = null
var Player = null

func enter_state():
	pass

func exit_state():
	pass
	
func update(_delta):
	return null

func player_movement(delta):
	if Player.movement_input.x > 0 and Player.inputs_active:
#		Player.velocity.x = Player.SPEED
		Player.velocity.x = move_toward(Player.velocity.x, Player.SPEED, delta * Player.SPEED*8)
		Player.last_direction = Vector2.RIGHT
	elif Player.movement_input.x < 0 and Player.inputs_active:
#		Player.velocity.x = -Player.SPEED
		Player.velocity.x = move_toward(Player.velocity.x, -Player.SPEED, delta * Player.SPEED*8)
		Player.last_direction = Vector2.LEFT
	else: 
#		Player.velocity.x = 0
		Player.velocity.x = move_toward(Player.velocity.x, 0, delta*Player.DRAG)
