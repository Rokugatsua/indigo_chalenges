extends Resource


export (String) var name: String

export (Texture) var texture: Texture


export (int) var point

export (int) var width
export (int) var height


func attack(grid:Vector2) -> Array:
	var attack_array = []
	for i in width:
		if i != grid.x:
			attack_array.append(Vector2(i, grid.y))
	for j in height:
		if j != grid.y:
			attack_array.append(Vector2(grid.x, j))
	
	return attack_array
		
