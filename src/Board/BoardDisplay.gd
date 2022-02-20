extends Node2D


enum STATES {INPUT, ADD, CHECK_ATTACK, CHECK_BOARD, REMOVE_BLOCK}


var board = preload("res://Board/BoardRes.tres")
var slot_display_scn = preload("res://Board/SlotDisplay.tscn")
var attack_zone_scn = preload("res://Board/AttackZone.tscn")
var block
var block_matched

var is_set_slot := false

export (int) var x_start
export (int) var y_start
export (int) var offset

onready var to_board_checking_timer = get_parent().get_node("ToBoardCheckingTimer")
onready var to_remove_blocks_timer = get_parent().get_node("ToRemoveBlocksTimer")



func _ready() -> void:
	board.slots = board.make_2d_array()
	board.attack_zones = board.make_2d_array()
	
	board.connect("slot_update", self, "_on_slot_update")
	board.connect("block_update", self, "_on_block_update")
	board.connect("game_finished", self, "_on_game_finished")
	
	add_slot_into_board()
	board.block = board.get_random_block()
	board.next_block = board.get_random_block()
	block = board.block
	


func _input(event: InputEvent) -> void:
	var pos = pixel_to_grid(get_global_mouse_position())
	if block.has_method("attack"):
		var posible_attack = block.attack(pos)
		move_attack_zone(posible_attack)
		
	if event.is_action_pressed("ui_touch"):
		if is_in_grid(pos):
			if board.slots[pos.x][pos.y] == null:
				board.set_slot(pos, block)
				board.add_score(block.point)
				is_set_slot = true
				remove_attack_zones()
				to_board_checking_timer.start()
				
	elif event.is_action_released("ui_touch"):
		if is_set_slot:
			board.block = board.next_block
			block = board.block
			board.next_block = board.get_random_block()
			is_set_slot = false
			


func state_to(state):
	match state:
		STATES.INPUT:
			pass
		STATES.ADD:
			pass
		STATES.CHECK_ATTACK:
			board.checking_attack_zones()
			state_to(STATES.CHECK_BOARD)
		STATES.CHECK_BOARD:
			block_matched = board.checking_board()
			if board.hits:
				draw_hits_zone(board.hits)
				remove_attack_zones()
			board.checking_hit()
			to_remove_blocks_timer.start()
		STATES.REMOVE_BLOCK:
			if block_matched != null:
				board.remove_blocks(block_matched)

func draw_hits_zone(hits: Array) -> void:
	var hits_zone = get_parent().get_node("HitZones")
	for zone in hits:
		var attack_zone = attack_zone_scn.instance()
		hits_zone.add_child(attack_zone)
		attack_zone.position = grid_to_pixel(zone)


func draw_posible_attack(posible_attack:Array) -> void:
	var attack_zones = get_parent().get_node("AttackZones")
	for attack in posible_attack:
		var attack_zone = attack_zone_scn.instance()
		attack_zones.add_child(attack_zone)
		if is_in_grid(attack):
			attack_zone.visible = true
			attack_zone.position = grid_to_pixel(attack)
		else:
			attack_zone.visible = false


func move_attack_zone(possible_attack:Array) -> void:
	var attack_zones = get_parent().get_node("AttackZones").get_children()
	for i in attack_zones.size():
		if i < possible_attack.size():
			if is_in_grid(possible_attack[i]):
				attack_zones[i].position = grid_to_pixel(possible_attack[i])
				attack_zones[i].visible = true
			else:
				attack_zones[i].visible = false


func remove_attack_zones():
	for child in get_parent().get_node("AttackZones").get_children():
		child.queue_free()


func insert_attack_zones(block, pos):
	for zone in block.attack(pos):
		if is_in_grid(zone):
			board.attack_zones[zone.x][zone.y] = true
	


func add_slot_into_board() -> void:
	for i in board.width:
		for j in board.height:
			var slot = slot_display_scn.instance()
			add_child(slot)
			slot.position = grid_to_pixel(Vector2(i,j))


func grid_to_pixel(grid:Vector2) -> Vector2:
	return Vector2(x_start + grid.x * offset, y_start + grid.y * offset)


func grid_to_index(grid:Vector2) -> int:
	return grid.x * board.height + grid.y


func pixel_to_grid(pixel:Vector2) -> Vector2:
	return Vector2(
		round((pixel.x - x_start) / offset),
		round((pixel.y - y_start) / offset)
	)


func is_in_grid(grid:Vector2) -> bool:
	if grid.x >= 0 and grid.x < board.width:
		if grid.y >= 0 and grid.y < board.height:
			return true
		
	return false


func _on_slot_update(indexes):
	for index in indexes:
		update_slot_display(index)


func _on_block_update(block):
	var pos = pixel_to_grid(get_global_mouse_position())
	if block.has_method("attack"):
		var posible_attack = block.attack(pos)
		draw_posible_attack(posible_attack)


func _on_game_finished(msg):
	for child in get_parent().get_node("AttackZones").get_children():
		child.queue_free()


func update_slot_display(index:Vector2):
	var slot_index = grid_to_index(index)
	var slot_display = get_child(slot_index)
	var item = board.slots[index.x][index.y]
	slot_display.display(item)


func _on_ToBoardCheckingTimer_timeout() -> void:
	state_to(STATES.CHECK_ATTACK)


func _on_ToRemoveBlocksTimer_timeout() -> void:
	state_to(STATES.REMOVE_BLOCK)
