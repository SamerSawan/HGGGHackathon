extends Node2D

var rock_scene = preload("res://scenes/entities/environment/rock.tscn") #access specific saw to be shot

@onready var shot_timer = $ShotTimer
@onready var Rock_container = $RockContainer

@export var first_shot_cooldown: float = 0
@export var shot_cooldown: float = 2
@export var Rock_speed_x: float = 70
@export var Rock_speed_y: float = 70 #Rock speeds
@export var shoot_on_start: bool = false
var direction_x: float
var direction_y: float

func _ready():
	shot_timer.wait_time = shot_cooldown #adjustable shot cooldown
	rotation_id() #get the rotation of the shooter
	SignalBus.player_died.connect(reset)
	if shoot_on_start:
		shoot()
	await get_tree().create_timer(first_shot_cooldown).timeout
	shot_timer.start(shot_cooldown) #or else the first timer countdown will start at 2 seconds
	
	
func shoot():
	var rock_instance = rock_scene.instantiate() 
	Rock_container.call_deferred("add_child", rock_instance) #create instance, add to node tree as child
	rock_instance.global_position = global_position #set rock position to shooter position
	rock_instance.Rock_speed = Vector2(Rock_speed_x*direction_x, Rock_speed_y*direction_y) #use positive y, corrected for up/down
	rock_instance.rotation = rotation #rotate so that the destroying raycast is facing the right way
#	rock_instance.scale = scale*0.6 #scale up the saws with the shooters
	
func _on_shot_timer_timeout():
	shoot()

func reset(): #for stages where i want Rocks to shoot off rip
	if shoot_on_start:
		shot_timer.start() #restart the shot timer so it doesnt double shoot
		shoot()

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

