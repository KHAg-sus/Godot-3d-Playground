extends StaticBody3D

signal status_couch(status: String)

func izone_entered(body):
	if body.name == "Player":
		status_couch.emit("Entered")

func izone_exited(body):
	if body.name == "Player":
		status_couch.emit("Exited")

func player_sit():
	set_collision_mask_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)

func player_stand():
	set_collision_mask_value(2, true)
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, true)
