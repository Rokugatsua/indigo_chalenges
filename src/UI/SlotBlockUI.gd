extends Control

onready var block_piece = $BlockPiece

var board = preload("res://Board/BoardRes.tres")

func _ready() -> void:
	board.connect("block_next_update", self, "_on_change_block")
	block_piece.texture = board.next_block.texture

func _on_change_block(block):
	block_piece.texture = block.texture
