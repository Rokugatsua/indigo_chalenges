extends Resource

signal slot_update(slots)
signal block_update(block)
signal block_next_update(block)
signal score_changed(score)
signal game_finished(msg)

export (int) var width
export (int) var height
export (Array, Resource) var blocks

var block: Resource setget _set_block
var next_block: Resource setget _set_next_block
var score: int
var slots = []
var attack_zones = []
var hits = []


func _set_next_block(val) -> void:
	next_block = val as Resource
	emit_signal("block_next_update", next_block)

func _set_block(val) -> void:
	block = val as Resource
	emit_signal("block_update", block)

func make_2d_array() -> Array:
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array


func set_slot(grid_index:Vector2, block:Resource) ->void:
	slots[grid_index.x][grid_index.y] = block
	emit_signal("slot_update", [grid_index])

	
func remove_slot(grid_index:Vector2) -> void:
	slots[grid_index.x][grid_index.y] = null
	emit_signal("slot_update", [grid_index])
	

func get_random_block() -> Resource:
	randomize()
	var rand = floor(rand_range(0, blocks.size()))
	return blocks[rand]


func add_score(value):
	score += value
	emit_signal("score_changed", score)


func checking_board():
	var dict = {}
	for i in width:
		for j in height:
			if slots[i][j]:
				if attack_zones[i][j]:
					hits.append(Vector2(i,j))
				var name = slots[i][j].name
				if dict.has(name):
					dict[name].append(Vector2(i,j))
				else:
					dict[name] = [Vector2(i,j)]
	
	return dict
	
func checking_hit():
	if hits.size() > 0:
		emit_signal("game_finished", "hit block piece")


func remove_blocks(dict):
	for key in dict:
		if dict[key].size() >= 3:
			for grid in dict[key]:
				remove_slot(grid)


func checking_attack_zones():
	attack_zones = make_2d_array()
	for i in width:
		for j in height:
			if slots[i][j]:
				for zone in slots[i][j].attack(Vector2(i,j)):
					if zone.x > 0 and zone.x < width:
						if zone.y > 0 and zone.y < height:
							attack_zones[zone.x][zone.y] = Vector2(zone.x,zone.y)


func reset_board():
	score = 0
	slots = make_2d_array()
	attack_zones = make_2d_array()
	hits = []
