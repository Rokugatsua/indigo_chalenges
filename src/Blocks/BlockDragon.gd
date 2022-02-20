extends Resource

export (String) var name: String

export (Texture) var texture: Texture


export (int) var point


func attack(grid_pos:Vector2) -> Array:
	var attack_array = []
	# tl 
	attack_array.append(grid_pos + Vector2.UP + Vector2.LEFT)
	attack_array.append(grid_pos + Vector2.UP)
	attack_array.append(grid_pos + Vector2.UP + Vector2.RIGHT)
	attack_array.append(grid_pos + Vector2.LEFT)
	attack_array.append(grid_pos + Vector2.RIGHT)
	attack_array.append(grid_pos + Vector2.DOWN + Vector2.LEFT)
	attack_array.append(grid_pos + Vector2.DOWN) 
	attack_array.append(grid_pos + Vector2.DOWN + Vector2.RIGHT)
	return attack_array
