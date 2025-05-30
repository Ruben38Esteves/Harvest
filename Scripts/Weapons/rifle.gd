class_name rifle
extends gun

func reload() -> void:
	if gunAmmo > 0:
		gunAmmo -= 1
		magazineAmmo += 1
		
