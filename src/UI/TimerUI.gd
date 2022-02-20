extends Control


var board = preload("res://Board/BoardRes.tres")

onready var timer := $Timer
onready var timer_progress := $VBoxContainer/TextureProgress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board.connect("block_update", self, "_on_block_update")
	timer.start()


func _on_block_update(block):
	timer.start()

func _process(delta: float) -> void:
	timer_progress.value = timer.time_left




func _on_Timer_timeout() -> void:
	board.emit_signal("game_finished", "Timeout")
