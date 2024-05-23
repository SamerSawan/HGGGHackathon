extends CharacterBody2D


@onready var standy_sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var particles = $Particles

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#player input
var horizontal_direction: float = 0
var vertical_direction: float = 0
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false
var inputs_active: bool = true

#player movement
const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const DRAG = 2000
var last_direction = Vector2.RIGHT
var climbs: int = 2

#mechanic
var can_dash = true
var jump_buffer: bool = false
var coyote_jump: bool = false
var perception: float = 1
var transparency: float
#states
var current_state = null
var prev_state = null

#nodes
@onready var STATES = $STATES
@onready var RAYCASTS = $Raycasts
@onready var animation_tree = $AnimationTree


func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	
	prev_state = STATES.IDLE 
	current_state = STATES.IDLE
	
	SignalBus.jump_buffer.connect(jump_buffer_func)
	SignalBus.coyote_jump.connect(coyote_jump_func)
	
func _process(_delta):
	particles_show()
	animation_handler()
	

func _physics_process(delta):
	if inputs_active:
		player_input()
	change_state(current_state.update(delta))
	
#	$Label.text = str(current_state.get_name())
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		prev_state.exit_state()
		current_state.enter_state()

func get_next_to_wall():
	for raycast in RAYCASTS.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null

func animation_handler():
	if horizontal_direction != 0: #turning
		standy_sprite.flip_h = (horizontal_direction == 1)
	if (velocity.x != 0 && is_on_floor()):
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_running"] = true
	if is_on_floor() && velocity.x == 0:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_running"] = false
		
func player_input():
	horizontal_direction = Input.get_axis("MoveLeft", "MoveRight") #returns -1 if first arg is pressed, else 1
	vertical_direction = Input.get_axis("MoveDown", "MoveUp")
	movement_input = Vector2(horizontal_direction, vertical_direction)

	if Input.is_action_pressed("Jump"):
		jump_input_actuation = true
	else: 
		jump_input_actuation = false

	#climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false
	
	#dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false
	
func respawn_anim(): #CONNECTED TO CAVE DOOR
	animation_tree["parameters/conditions/is_respawning"] = true
	velocity = Vector2.ZERO
	inputs_active = false
	await get_tree().create_timer(0.5).timeout #just to give it time to play
	inputs_active = true
	animation_tree["parameters/conditions/is_respawning"] = false

func jump_buffer_func(): #catches signal from FALL state
	$JumpBuffer.start()
	jump_buffer = true

func _on_jump_buffer_timeout():
	jump_buffer = false

func coyote_jump_func(): #couldnt find anywhere in states, putting it here
	$CoyoteTimer.start()
	coyote_jump = true
		
func _on_coyote_timer_timeout():
	coyote_jump = false

func perception_limits():
	if perception > 5:
		perception = 5
	if perception <= 1:
		perception = 1


func _on_perception_timer_timeout():
	perception -= 0.2 #decrease per tick (seconds)
	perception_limits()
	SignalBus.perception_check.emit()

func particles_show():
	particles.modulate = Color(1,1,1,transparency)
	if perception > 2:
		particles.visible = true
		transparency = (0.21*perception - 0.2)
	else:
		particles.visible = false
