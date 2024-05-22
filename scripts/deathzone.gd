extends Area2D


func _on_body_entered(_body):
	SignalBus.emit_signal("deathzone") #handled in cave_door since thats the respawn point
