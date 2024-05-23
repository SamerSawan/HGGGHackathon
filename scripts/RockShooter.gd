extends Node2D

var rock_scene = preload("res://scenes/entities/environment/rock.tscn") #access specific saw to be shot
var Player

@onready var shot_timer = $ShotTimer
@onready var Rock_container = $RockContainer

@export var first_shot_cooldown: float = 0
@export var shot_cooldown_initial: float = 1
@export var shoot_on_start: bool = false
@export var rock_speed_x: float = 100 #INITIAL rock speeds
@export var rock_speed_y: float = 100

var shot_cooldown: float = shot_cooldown_initial
var perception: float
var direction_x: float
var direction_y: float
var Rock_speed_x: float = 70
var Rock_speed_y: float = 70 #Rock speeds

func _ready():
	shot_timer.wait_time = shot_cooldown_initial #adjustable shot cooldown
	rotation_id() #get the rotation of the shooter
	SignalBus.player_died.connect(reset) 
	SignalBus.perception_check.connect(perception_change) #triggered every second from player
	Player = get_tree().get_first_node_in_group("player")
	
	if shoot_on_start:
		shoot()
	await get_tree().create_timer(first_shot_cooldown).timeout
	shot_timer.start(shot_cooldown_initial) #or else the first timer countdown will start at 2 seconds
	
	
func shoot():
	var rock_instance = rock_scene.instantiate() 
	Rock_container.call_deferred("add_child", rock_instance) #create instance, add to node tree as child
	rock_instance.global_position = global_position #set rock position to shooter position
	rock_instance.Rock_speed = Vector2(Rock_speed_x*direction_x, Rock_speed_y*direction_y) #use positive y, corrected for up/down
	rock_instance.rotation = rotation #rotate so that the destroying raycast is facing the right way
#	rock_instance.scale = scale*0.6 #scale up the saws with the shooters
	
func _on_shot_timer_timeout():
	shoot()
	shot_timer.start(shot_cooldown)

func reset(): #for stages where i want Rocks to shoot off rip
	if shoot_on_start:
		shot_timer.start() #restart the shot timer so it doesnt double shoot
		shoot()

func perception_change():
	if Player.perception > 0: #stop it from going negative and/or crashing somehow
		perception = Player.perception #from 1 to 5
		Rock_speed_x = rock_speed_x*(1.0/perception)
		Rock_speed_y = rock_speed_y*(1.0/perception)
		shot_cooldown = shot_cooldown_initial/(2.5/perception)
	
func rotation_id(): #shoot the Rocks out correctly at 4 different angles
	#i had to round the numbers down or it would be inconsistent
	if abs(int(fmod(rotation, deg_to_rad(360)))) == 0: #x = 0, Y = 1
		direction_x = 0
		direction_y = 1
	if abs(int(fmod(rotation, deg_to_rad(360)))) == 1: #90 deg X = 1, Y=0
		direction_x = 1
		direction_y = 0
	if abs(int(fmod(rotation, deg_to_rad(360)))) == 3: #180 deg X = 0, Y = -1
		direction_x = 0
		direction_y = -1
	if abs(int(fmod(rotation, deg_to_rad(360)))) == 4: #270 deg X = -1, Y = 0
		direction_x = -1
		direction_y = 0

