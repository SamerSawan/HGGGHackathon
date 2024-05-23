extends Node
#autoloaded in the project settings, so we dont need to call references to access functions
@onready var musicPlayer = $MusicPlayer

#var hurt = preload("res://martian_mike_assets/martian_mike_assets/audio/hurt.wav") keeping as example

var cave_id: int = 0
#MAY2024 THE PAUSE MENU BUTTONS ARE BEING MANAGED/CONNECTED FROM HERE AS WELL
var musicToggle: bool = true
var level_changed: bool = false #starts false or it will stay false
var soundToggle: bool = true
#level_changed will be changed to true on level script _ready() (start of every level)
#and changed back to false after connecting the pause

var bus
var pitch
var soundStatus: bool = true #will use these to hold the state of the togglers
var musicStatus: bool = true

func _process(_delta):
	if level_changed: #will activate at level start
		connect_pause_menu() 
	

func connect_pause_menu(): #this function connect's the pause button for an individual level
		var pauseMenu = get_tree().get_nodes_in_group("pauseMenu") #fetch level's pauseMenu node
		
		for pause in pauseMenu:
			pause.musicToggler.connect(_on_music_button_pressed) #connect the music button toggle via signal
			pause.soundToggler.connect(_on_sound_button_pressed) #connect sound
			
		level_changed = false #returns to false so it doesnt spam unnecessarily

func _on_music_button_pressed(): #toggles true/false for the music when pausemenu's button is pressed
	musicToggle = !musicToggle
	
	if musicToggle == false:
		musicPlayer.stop()

	if musicToggle == true:
		musicPlayer.play()


func _on_sound_button_pressed(): #switch sound togler between true and false
	soundToggle = !soundToggle
	
func play_sfx(sfx_name: String): #purely exists to play sound effects
	var stream = null
	pitch = 1
	if soundToggle:	
		if sfx_name == "hurt":
#			stream = hurt
			bus = "Master"
		elif sfx_name == "jump":
#			stream = jump
			bus = "Half Pitch"
		elif sfx_name == "yippee":
#			stream = yippee
			bus = "Master"
		elif sfx_name == "boing":
#			stream = boing
			bus = "Master"
		elif sfx_name == "dash":
#			stream = dash
			bus = "Master"
		elif sfx_name == "succ":
#			stream = succ
			pitch = 1
			bus = "Master"
		elif sfx_name == "fling":
#			stream = fling
			bus = "Speed"
		else:
			print("invalid sfx name")
			return
			
			
		var asp = AudioStreamPlayer.new()
		asp.stream = stream
		asp.name = "SFX"
		asp.volume_db = -5
		asp.pitch_scale = pitch
		asp.bus = bus
		add_child(asp)
		
		asp.play()
		
		await asp.finished
		asp.queue_free() #wait for the finished signal then delete the child
