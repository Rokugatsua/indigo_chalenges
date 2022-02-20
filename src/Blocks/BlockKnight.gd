extends Resource


export (String) var name: String

export (Texture) var texture: Texture


export (int) var point


func attack(grid:Vector2) -> Array:
	var attack_array = []
	attack_array.append(grid + (Vector2.UP * 2) + Vector2.LEFT)
	attack_array.append(grid + (Vector2.UP * 2) + Vector2.RIGHT)
	attack_array.append(grid + (Vector2.LEFT * 2) + Vector2.UP)
	attack_array.append(grid + (Vector2.LEFT * 2) + Vector2.DOWN)
	attack_array.append(grid + (Vector2.RIGHT * 2) + Vector2.UP)
	attack_array.append(grid + (Vector2.RIGHT * 2) + Vector2.DOWN)
	attack_array.append(grid + (Vector2.DOWN * 2) + Vector2.LEFT)
	attack_array.append(grid + (Vector2.DOWN * 2) + Vector2.RIGHT)
	return attack_array
