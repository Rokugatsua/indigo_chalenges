extends Resource


export (String) var name: String

export (Texture) var texture: Texture

export (int) var point

export (int) var width
export (int) var height


func attack(grid:Vector2) -> Array:
	var attack_array = []
	
	var side = width if width >= height else height
	
	for i in side:
		if i > 0:
			attack_array.append(grid + (Vector2.UP + Vector2.LEFT) * i)
			attack_array.append(grid + (Vector2.UP + Vector2.RIGHT) * i)
			attack_array.append(grid + (Vector2.DOWN + Vector2.LEFT) * i)
			attack_array.append(grid + (Vector2.DOWN + Vector2.RIGHT) * i)
	
	return attack_array
