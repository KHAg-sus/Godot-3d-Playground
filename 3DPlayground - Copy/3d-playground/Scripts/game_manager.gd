extends Node

var can_sit := false
var sitting: bool = false

func _on_couch_status(status):
	if status == "Entered":
		can_sit = true
	elif status == "Exited":
		can_sit = false

func _on_player_interact():
	if can_sit:
		if sitting:
			%Player.stand_up()
			%Couch.player_stand()
		else:
			%Couch.player_sit()
			%Player.sit_on_couch()
		sitting = !sitting
