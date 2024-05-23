# Made by 'jar' on YouTube 
# Feel free to use this and modify it in anyway you wish
# https://github.com/jar-yt

extends Node2D

var Player
var candle
#var candle = preload("res://scenes/other/candle_scene.tscn")

@onready var pin := get_node("Pin")
@onready var pin_start := get_node("PinStart")
@onready var pin_end := get_node("PinEnd")
@onready var sprite_2d = $OuterSweetSpot/Sprite2D
var original_color
var transparency: float = 0
var fading: bool = true

var stop_pin := false
var passed_outer_area := false

var pin_outer_hit := false

@export var pin_time : float = 2

func _ready():
	Player = get_tree().get_first_node_in_group("player")
	candle = get_tree().get_first_node_in_group("candle")
	original_color = sprite_2d.modulate
	pin.transform.origin = pin_start.transform.origin #just in case

func _process(_delta):
	reached_end()
	
func _physics_process(delta): # Updating with physics because it was less consistent and accurate
	_call_pin(pin_time, delta)
	reset_interface()
	menu_fade()

# Data: ["normal_reload", "quick_reload", "active_reload"]
func _call_pin(reload_time, delta): #aka pin activation via R key
	if Input.is_action_just_pressed("Meditate"):
		if pin_outer_hit && $Pin/PinSprite.visible:
			sprite_2d.modulate = Color(0, 1, 0)
			$Pin/PinSprite.visible = false
			Player.perception += 1
#			SignalBus.perception_check.emit()
		elif !pin_outer_hit && !passed_outer_area && transparency > 1: #'too early'
			stop_pin = false
			$Pin/PinSprite.visible = false
		else:
			return
			
	#bottom code here is what makes it move
	if self.visible && pin.transform.origin <= pin_end.transform.origin:
		pin.transform.origin.x += ((pin_end.transform.origin.x - pin_start.transform.origin.x) / reload_time) * delta
		

func reset_interface():
	if Input.is_action_just_pressed("MeditateMenu"):
		stop_pin = false
		passed_outer_area = false #timer
		fading = !fading
		
func menu_fade(): #control how fast the menu will appear/disappear, activated with Q
	if fading and transparency > 0:
		transparency -= 0.03
		self.modulate = Color(1,1,1, transparency)
		candle.modulate = Color(1,1,1, transparency)
	if !fading and transparency < 1:
		$Pin/PinSprite.visible = true
		pin.transform.origin = pin_start.transform.origin #even pauses until fully visible for some reason
		transparency += 0.03
		self.modulate = Color(1,1,1, transparency)
		candle.modulate = Color(1,1,1, transparency)
		
# ===== SIGNALS =====
func _on_pin_area_entered(area): #pin entered
	if area.is_in_group("Outer"):
		pin_outer_hit = true

func _on_pin_area_exited(area): #pin passed
	if area.is_in_group("Outer"):
		sprite_2d.modulate = original_color
		pin_outer_hit = false
		passed_outer_area = true

func reached_end(): #reset at end
	if round(pin.global_position.x) == round(pin_end.global_position.x): #round or wont work
		pin.global_position.x = pin_start.global_position.x
		$Pin/PinSprite.visible = true
		stop_pin = false
		pin_outer_hit = false
		passed_outer_area = false
		pin.transform.origin = pin_start.transform.origin
